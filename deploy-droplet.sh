#!/bin/bash
set -e

echo "=== CareRide Droplet Deployment Script ==="
echo "This script will deploy your backend to the droplet"
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

print_step "1. Going to project directory"
cd /opt/care-ride

print_step "2. Pulling latest code from GitHub"
git pull

print_step "3. Setting up environment file"
if [ ! -f "backend/backend.env" ]; then
    cp backend/backend.env.example backend/backend.env
    echo "Created backend.env from example"
fi

print_step "4. Generating JWT secret"
JWT_SECRET=$(openssl rand -hex 48)
echo "Generated JWT secret: ${JWT_SECRET:0:20}..."

print_step "5. Updating environment variables"
cat > backend/backend.env << EOF
# Database connection
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/caredb
SPRING_DATASOURCE_USERNAME=careuser
SPRING_DATASOURCE_PASSWORD=changeme_db_password

# Security
JWT_SECRET=$JWT_SECRET

# Spring Boot settings
SPRING_PROFILES_ACTIVE=prod
SPRING_FLYWAY_ENABLED=false
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_DATASOURCE_HIKARI_INITIALIZATION_FAIL_TIMEOUT=0

# JVM memory settings for 1GB droplet
JAVA_TOOL_OPTIONS=-Xms128m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=300

# Logging
LOGGING_LEVEL_ROOT=INFO

# Mail (disabled for now)
SPRING_MAIL_HOST=localhost
SPRING_MAIL_PORT=2525
SPRING_MAIL_USERNAME=dummy
SPRING_MAIL_PASSWORD=dummy
EOF

print_step "6. Stopping any running containers"
docker compose down

print_step "7. Starting database"
docker compose up -d db

print_step "8. Waiting for database to be healthy..."
echo "This may take 30-60 seconds..."
COUNTER=0
while ! docker ps --format '{{.Names}} {{.Status}}' | grep -q 'db.*(healthy)'; do
    if [ $COUNTER -gt 60 ]; then
        print_error "Database failed to start after 60 seconds"
        docker logs db
        exit 1
    fi
    echo -n "."
    sleep 3
    COUNTER=$((COUNTER + 3))
done
echo
print_step "Database is healthy!"

print_step "9. Building backend (this may take 2-3 minutes)"
docker compose build --no-cache backend

print_step "10. Starting backend"
docker compose up -d backend

print_step "11. Waiting for backend to start..."
COUNTER=0
while ! docker logs backend 2>&1 | grep -q 'Started CareRideApplication'; do
    if [ $COUNTER -gt 120 ]; then
        print_error "Backend failed to start after 2 minutes"
        echo "Backend logs:"
        docker logs backend
        exit 1
    fi
    echo -n "."
    sleep 5
    COUNTER=$((COUNTER + 5))
done
echo
print_step "Backend started successfully!"

print_step "12. Testing backend"
if curl -s -I http://127.0.0.1:8080/ | head -1 | grep -q "HTTP/1.1"; then
    print_step "✅ Backend is responding!"
    echo "Backend status:"
    curl -s -I http://127.0.0.1:8080/ | head -1
else
    print_warning "Backend might not be responding correctly"
    echo "Curl output:"
    curl -I http://127.0.0.1:8080/ || true
fi

print_step "13. Container status"
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'

print_step "14. Environment check"
echo "Key environment variables in backend container:"
docker exec backend env | grep -E 'SPRING_DATASOURCE_URL|JWT_SECRET' | head -2

echo
echo "=== DEPLOYMENT COMPLETE ==="
echo
echo "✅ Database: Running and healthy"
echo "✅ Backend: Running on port 8080"
echo "✅ Environment: Configured"
echo
echo "Next steps:"
echo "1. Add DNS A records at your domain registrar:"
echo "   - @ (root) → $(curl -s ifconfig.me)"
echo "   - www → $(curl -s ifconfig.me)"
echo
echo "2. After DNS propagates, run SSL setup:"
echo "   sudo certbot --nginx -d careridesolutionspa.com -d www.careridesolutionspa.com"
echo
echo "3. Test your site:"
echo "   https://careridesolutionspa.com"
echo
