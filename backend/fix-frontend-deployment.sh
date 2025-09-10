#!/bin/bash
set -euo pipefail

echo "=== Care Ride Frontend Deployment Fix ==="
echo "This script will:"
echo "1. Clone/update the repository"
echo "2. Install Node.js if needed"
echo "3. Build Angular from the frontend subdirectory"
echo "4. Sync built files to nginx web root"
echo "5. Set proper permissions"
echo "6. Reload nginx"
echo "7. Test the deployment"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# 1. Setup repository
echo "Step 1: Setting up repository..."
REPO_DIR="/opt/care-ride-frontend-src"
NGINX_ROOT="/var/www/care-ride-frontend"

if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Cloning repository..."
    rm -rf "$REPO_DIR"
    git clone --depth=1 https://github.com/chhabi86/care-ride.git "$REPO_DIR"
else
    echo "Updating existing repository..."
    cd "$REPO_DIR"
    git fetch origin main
    git reset --hard origin/main
fi

# 2. Install Node.js if needed
echo "Step 2: Checking Node.js installation..."
if ! command -v node >/dev/null 2>&1; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
else
    echo "Node.js already installed: $(node --version)"
fi

# 3. Build Angular
echo "Step 3: Building Angular application..."
cd "$REPO_DIR/frontend"

echo "Installing dependencies..."
npm install --legacy-peer-deps || npm install

echo "Building production bundle..."
if ! npx ng build --configuration production; then
    echo "Production build failed, trying default build..."
    npx ng build
fi

# 4. Find and sync built files
echo "Step 4: Syncing built files to nginx root..."
DIST_DIR=$(find dist -name "index.html" -type f | head -1 | dirname)

if [ -z "$DIST_DIR" ] || [ ! -f "$DIST_DIR/index.html" ]; then
    echo "ERROR: Could not find built Angular files with index.html"
    echo "Available files in dist:"
    find dist -type f | head -20
    exit 1
fi

echo "Found built files in: $DIST_DIR"
echo "Contents:"
ls -la "$DIST_DIR"

# Create nginx root and sync files
mkdir -p "$NGINX_ROOT"
rm -rf "$NGINX_ROOT"/*
cp -r "$DIST_DIR"/* "$NGINX_ROOT/"

# 5. Set proper permissions
echo "Step 5: Setting proper permissions..."
chown -R www-data:www-data "$NGINX_ROOT"
find "$NGINX_ROOT" -type d -exec chmod 755 {} \;
find "$NGINX_ROOT" -type f -exec chmod 644 {} \;

echo "Final nginx root contents:"
ls -la "$NGINX_ROOT"

# 6. Test nginx config and reload
echo "Step 6: Testing nginx configuration..."
if nginx -t; then
    echo "Nginx config is valid, reloading..."
    systemctl reload nginx
else
    echo "ERROR: Nginx configuration test failed"
    exit 1
fi

# 7. Test deployment
echo "Step 7: Testing deployment..."
echo "Testing root URL..."
if curl -sSf https://careridesolutionspa.com/ >/dev/null; then
    echo "✓ Root URL is accessible"
else
    echo "✗ Root URL failed"
fi

echo "Testing index.html directly..."
if curl -sSf https://careridesolutionspa.com/index.html >/dev/null; then
    echo "✓ index.html is accessible"
else
    echo "✗ index.html failed"
fi

echo "Testing SPA route..."
if curl -sSf https://careridesolutionspa.com/contact >/dev/null; then
    echo "✓ SPA routes are working"
else
    echo "✗ SPA routes failed (may be normal if Angular handles client-side)"
fi

echo ""
echo "=== Deployment Complete ==="
echo "Visit: https://careridesolutionspa.com"
echo ""
echo "If you still see errors, check:"
echo "- nginx error log: tail -20 /var/log/nginx/error.log"
echo "- nginx config: nginx -T | grep -A 10 -B 5 'server_name careridesolutionspa.com'"
