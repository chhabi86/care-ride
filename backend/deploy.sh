#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")" && pwd)
echo "Deploy script running from $ROOT"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo to install packages and manage services." >&2
  exit 1
fi

# Allow non-interactive runs by using the DOMAIN environment variable.
# If DOMAIN is not set and we have a TTY, prompt the user. Otherwise fail early.
if [ -z "${DOMAIN:-}" ]; then
  if [ -t 0 ]; then
    read -p "Enter domain for site (example.com): " DOMAIN
  else
    echo "Error: DOMAIN is not set and no TTY is attached. Provide DOMAIN as an environment variable or via the DEPLOY_DOMAIN secret." >&2
    exit 1
  fi
fi

apt update && apt upgrade -y
apt install -y git curl nginx certbot python3-certbot-nginx rsync

# install docker
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi
if ! command -v docker-compose >/dev/null 2>&1; then
  apt install -y docker-compose
fi

cd $ROOT

if [ ! -d ".git" ]; then
  echo "Initializing git..."
  git init
  git remote add origin https://github.com/your/repo.git || true
fi

echo "Preparing environment file (backend.env)."
if [ -f backend.env.example ] && [ ! -f backend.env ]; then
  cp backend.env.example backend.env
  echo "Created backend.env from example — edit it with real secrets now (before next deploy)."
fi

echo "Stopping any existing stack (ignore errors if first run)..."
docker compose -f docker-compose.yml down --remove-orphans || true

echo "Building backend image (docker-compose.yml)..."
docker compose -f docker-compose.yml build backend
echo "(Skipping containerized frontend – using static build from external repo)"

PGADMIN_COMPOSE_ARGS=""
PGADMIN_PORT=${PGADMIN_PORT:-5050}
if [ "${PROFILE_PGADMIN:-0}" = "1" ]; then
  if ss -ltn | awk '{print $4}' | grep -q ":$PGADMIN_PORT$"; then
    echo "Requested pgadmin but port $PGADMIN_PORT is busy; skipping pgadmin."
  else
    if [ -f docker-compose.pgadmin.yml ]; then
      PGADMIN_COMPOSE_ARGS="-f docker-compose.pgadmin.yml"
      echo "Including pgadmin via docker-compose.pgadmin.yml"
    else
      echo "docker-compose.pgadmin.yml missing; cannot enable pgadmin." >&2
    fi
  fi
else
  echo "PgAdmin not requested (set PROFILE_PGADMIN=1 to include)."
fi

  echo "Starting containers (db + backend only)..."
  docker compose -f docker-compose.yml $PGADMIN_COMPOSE_ARGS up -d db backend

echo "Deploying external Angular frontend (static assets)"
FRONTEND_REPO_URL=${FRONTEND_REPO_URL:-https://github.com/chhabi86/care-ride.git}
FRONTEND_DIR=/opt/care-ride-frontend-src
TARGET_STATIC_DIR=/var/www/care-ride-frontend

if [ ! -d "$FRONTEND_DIR/.git" ]; then
  echo "Cloning frontend repo $FRONTEND_REPO_URL"
  rm -rf "$FRONTEND_DIR" || true
  git clone --depth=1 "$FRONTEND_REPO_URL" "$FRONTEND_DIR"
else
  echo "Updating existing frontend repo..."
  (cd "$FRONTEND_DIR" && git fetch --depth=1 origin main || true && git reset --hard origin/main || true)
fi

if ! command -v node >/dev/null 2>&1; then
  echo "Installing Node.js (apt)"
  apt install -y nodejs npm || true
fi

echo "Installing frontend dependencies..."
cd "$FRONTEND_DIR"
if [ -f package-lock.json ]; then
  npm ci --legacy-peer-deps || npm install
else
  npm install
fi

echo "Building Angular production bundle..."
if ! npx ng build --configuration production; then
  echo "Production build failed, trying default build." >&2
  npx ng build || true
fi

DIST_DIR=$(find dist -maxdepth 3 -type f -name index.html -printf '%h\n' 2>/dev/null | head -n1 || true)
if [ -z "$DIST_DIR" ]; then
  DIST_DIR=$(find dist -mindepth 1 -maxdepth 2 -type d | head -n1 || true)
fi
if [ -n "$DIST_DIR" ]; then
  mkdir -p "$TARGET_STATIC_DIR"
  rsync -a --delete "$DIST_DIR/" "$TARGET_STATIC_DIR/"
  echo "Synced frontend dist from $DIST_DIR to $TARGET_STATIC_DIR"
else
  echo "WARNING: Could not locate built Angular dist directory. Frontend not updated." >&2
fi
cd "$ROOT"

echo "Configuring nginx for $DOMAIN (static frontend + /api proxy)"
NGINX_CONF="/etc/nginx/sites-available/care-ride"
if [ -f nginx/care-ride.conf ]; then
  cp nginx/care-ride.conf $NGINX_CONF
else
  echo "nginx/care-ride.conf not found; writing minimal default." >&2
  cat > $NGINX_CONF <<EOF
upstream backend_api { server 127.0.0.1:8080; }
server {
  listen 80;
  server_name $DOMAIN www.$DOMAIN;
  root $TARGET_STATIC_DIR;
  index index.html;
  location /api/ { proxy_pass http://backend_api/; }
  location / {
    try_files $uri $uri/ /index.html;
  }
}
EOF
fi
sed -i "s/server_name example.com www.example.com;/server_name $DOMAIN www.$DOMAIN;/" $NGINX_CONF || true
ln -sf $NGINX_CONF /etc/nginx/sites-enabled/care-ride
nginx -t && systemctl reload nginx

echo "Obtaining TLS certificate via certbot..."
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN || true

echo "Deployment complete. Visit https://$DOMAIN"
