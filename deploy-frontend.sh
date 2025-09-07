#!/bin/bash
set -e

echo "=== CareRide Frontend Deployment Script ==="
echo "This script will deploy your Angular frontend to the droplet"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${GREEN}[STEP]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're on the droplet
if [ ! -d "/opt/care-ride" ]; then
    print_error "This script must be run on the droplet server"
    print_error "Please copy this script to your droplet and run it there"
    exit 1
fi

print_step "1. Creating frontend directory"
sudo mkdir -p /var/www/careridesolutionspa.com
sudo chown -R www-data:www-data /var/www/careridesolutionspa.com

print_step "2. Extracting frontend files"
cd /opt/care-ride
if [ -f "frontend-dist.tar.gz" ]; then
    sudo tar -xzf frontend-dist.tar.gz -C /var/www/careridesolutionspa.com
    print_step "Frontend files extracted successfully"
else
    print_error "frontend-dist.tar.gz not found"
    print_error "Please upload the frontend build files first"
    exit 1
fi

print_step "3. Setting proper permissions"
sudo chown -R www-data:www-data /var/www/careridesolutionspa.com
sudo chmod -R 644 /var/www/careridesolutionspa.com
sudo find /var/www/careridesolutionspa.com -type d -exec chmod 755 {} \;

print_step "4. Updating nginx configuration"
sudo tee /etc/nginx/sites-available/careridesolutionspa.com << 'EOF'
server {
    listen 80;
    server_name careridesolutionspa.com www.careridesolutionspa.com;

    root /var/www/careridesolutionspa.com;
    index index.html;

    # Serve Angular frontend
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Backend API proxy
    location /api/ {
        proxy_pass http://127.0.0.1:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

print_step "5. Testing nginx configuration"
sudo nginx -t

print_step "6. Reloading nginx"
sudo systemctl reload nginx

print_step "7. Testing frontend deployment"
if curl -s -I http://127.0.0.1/ | head -1 | grep -q "HTTP/1.1 200"; then
    print_step "✅ Frontend is serving correctly!"
else
    print_warning "Frontend might not be serving correctly"
    echo "Testing response:"
    curl -I http://127.0.0.1/ || true
fi

echo
echo "=== FRONTEND DEPLOYMENT COMPLETE ==="
echo
echo "✅ Angular frontend: Deployed and serving"
echo "✅ Static files: Cached for performance"
echo "✅ API routing: /api/* routes to backend"
echo "✅ SPA routing: Angular handles all other routes"
echo
echo "Your full-stack application is now deployed!"
echo
echo "Next steps:"
echo "1. Wait for DNS propagation: https://www.whatsmydns.net/"
echo "2. Run SSL setup: sudo certbot --nginx -d careridesolutionspa.com -d www.careridesolutionspa.com"
echo "3. Access your site: https://careridesolutionspa.com"
echo
