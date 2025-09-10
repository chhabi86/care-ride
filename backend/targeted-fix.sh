#!/bin/bash
set -euo pipefail

echo "=== Targeted Fix for 403/500 Errors ==="

# Diagnostic first
echo "Step 1: Diagnosing current state..."
echo "Current nginx root contents:"
ls -la /var/www/care-ride-frontend/ 2>/dev/null || echo "Directory doesn't exist"

echo "File count in nginx root:"
find /var/www/care-ride-frontend -type f 2>/dev/null | wc -l || echo "0"

echo "Current nginx config for domain:"
nginx -T 2>/dev/null | sed -n '/server_name.*careridesolutionspa/,/^}/p' || echo "Config not found"

echo "Recent nginx errors:"
tail -10 /var/log/nginx/error.log 2>/dev/null || echo "No error log"

echo ""
echo "Step 2: Force rebuild and proper deployment..."

# Ensure repo exists and is updated
REPO_DIR="/opt/care-ride-frontend-src"
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Cloning fresh repository..."
    rm -rf "$REPO_DIR"
    git clone --depth=1 https://github.com/chhabi86/care-ride.git "$REPO_DIR"
fi

cd "$REPO_DIR"
git fetch origin main
git reset --hard origin/main

# Install Node.js if missing
if ! command -v node >/dev/null 2>&1; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
fi

# Build Angular
echo "Building Angular application..."
cd "$REPO_DIR/frontend"
rm -rf node_modules dist 2>/dev/null || true
npm install --legacy-peer-deps
npx ng build --configuration production

# Verify build output
echo "Build output structure:"
find dist -type f -name "*.html" -o -name "*.js" -o -name "*.css" | head -10

# Find the correct dist directory
DIST_DIR=""
for candidate in "dist/care-ride-frontend/browser" "dist/care-ride-frontend" "dist/frontend" "dist"; do
    if [ -f "$candidate/index.html" ]; then
        DIST_DIR="$candidate"
        break
    fi
done

if [ -z "$DIST_DIR" ] || [ ! -f "$DIST_DIR/index.html" ]; then
    echo "ERROR: Cannot find index.html in build output"
    echo "Available files:"
    find dist -type f | head -20
    exit 1
fi

echo "Found built files in: $DIST_DIR"
echo "Contents:"
ls -la "$DIST_DIR" | head -10

# Deploy to nginx root
echo "Deploying to nginx root..."
mkdir -p /var/www/care-ride-frontend
rm -rf /var/www/care-ride-frontend/*
cp -r "$DIST_DIR"/* /var/www/care-ride-frontend/

# Set proper ownership and permissions
chown -R www-data:www-data /var/www/care-ride-frontend
find /var/www/care-ride-frontend -type d -exec chmod 755 {} \;
find /var/www/care-ride-frontend -type f -exec chmod 644 {} \;

echo "Final nginx root contents:"
ls -la /var/www/care-ride-frontend/

# Ensure nginx config is correct
echo "Checking nginx config..."
CONFIG_FILE="/etc/nginx/sites-available/careridesolutionspa.com"

# Fix root path if needed
if grep -q "root /var/www/html" "$CONFIG_FILE" 2>/dev/null; then
    echo "Fixing nginx root path..."
    sed -i 's|root /var/www/html|root /var/www/care-ride-frontend|g' "$CONFIG_FILE"
fi

# Ensure try_files is set for SPA
if ! grep -q "try_files.*index.html" "$CONFIG_FILE" 2>/dev/null; then
    echo "Adding SPA fallback to nginx config..."
    # This is a basic fix - might need manual adjustment
    sed -i '/location \/ {/a\    try_files $uri $uri/ /index.html;' "$CONFIG_FILE"
fi

# Test and reload nginx
echo "Testing nginx configuration..."
if nginx -t; then
    echo "Reloading nginx..."
    systemctl reload nginx
else
    echo "Nginx config test failed!"
    nginx -t
    exit 1
fi

# Final verification
echo ""
echo "Step 3: Verification..."
sleep 2

echo "Testing root URL:"
if curl -sSf https://careridesolutionspa.com/ >/dev/null 2>&1; then
    echo "✓ Root URL accessible"
else
    echo "✗ Root URL failed"
    curl -sSI https://careridesolutionspa.com/ | head -5
fi

echo "Testing index.html:"
if curl -sSf https://careridesolutionspa.com/index.html >/dev/null 2>&1; then
    echo "✓ index.html accessible"
else
    echo "✗ index.html failed"
    curl -sSI https://careridesolutionspa.com/index.html | head -5
fi

echo ""
echo "=== Fix Complete ==="
echo "If still seeing issues:"
echo "1. Check: tail -20 /var/log/nginx/error.log"
echo "2. Verify: ls -la /var/www/care-ride-frontend/"
echo "3. Config: nginx -T | grep -A 10 'server_name.*careridesolutionspa'"
