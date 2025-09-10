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
# Stop all existing containers that might be using our ports
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true
# Also try to stop with compose files
docker compose -f docker-compose.yml down --remove-orphans 2>/dev/null || true
docker-compose down 2>/dev/null || true

echo "Building images (backend + frontend)..."
docker compose -f docker-compose.yml build

PGADMIN_COMPOSE_ARGS=""
PGLADMIN_PORT=${PGADMIN_PORT:-5050}
if [ "${PROFILE_PGADMIN:-0}" = "1" ]; then
  if ss -ltn | awk '{print $4}' | grep -q ":$PGADMIN_PORT$"; then
    echo "Requested pgadmin but port $PGADMIN_PORT is busy; skipping pgadmin."
  else
    if [ -f docker-compose.pgadmin.yml ]; then
      PGADMIN_COMPOSE_ARGS="-f docker-compose.pgladmin.yml"
      echo "Including pgadmin via docker-compose.pgladmin.yml"
    else
      echo "docker-compose.pgladmin.yml missing; cannot enable pgladmin." >&2
    fi
  fi
else
  echo "PgAdmin not requested (set PROFILE_PGLADMIN=1 to include)."
fi

  echo "Starting containers (db + backend + frontend)..."
  docker compose -f docker-compose.yml $PGLADMIN_COMPOSE_ARGS up -d

echo "Frontend will be deployed as Docker container (see docker-compose.yml frontend service)"

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
