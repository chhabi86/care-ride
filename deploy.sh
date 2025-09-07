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

echo "Copy example env to actual env (edit credentials after)."
# Current expected layout: backend/backend.env(.example). Compose refers to ./backend/backend.env
if [ -f backend/backend.env.example ] && [ ! -f backend/backend.env ]; then
  cp backend/backend.env.example backend/backend.env
  echo "Created backend/backend.env from example — edit it with real secrets now:"
  echo "  sudo nano backend/backend.env"
fi

# Also create a root-level backend.env if some compose variant (older) expects it.
if [ -f backend/backend.env ] && [ ! -f backend.env ]; then
  if ln -s backend/backend.env backend.env 2>/dev/null; then
    echo "Created symlink backend.env -> backend/backend.env"
  else
    cp backend/backend.env backend.env
    echo "Copied backend/backend.env to backend.env (symlink unavailable)."
  fi
fi

if [ -x backend/deploy.sh ]; then
  echo "Delegating to backend/deploy.sh (enhanced static frontend deploy)..."
  exec backend/deploy.sh
fi

echo "backend/deploy.sh missing; performing minimal legacy compose deploy (no static frontend sync)"
echo "Building and starting containers..."
docker compose build
docker compose up -d db backend
echo "Minimal deploy done. Provide backend/deploy.sh for full static frontend workflow."
