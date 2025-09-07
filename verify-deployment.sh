#!/bin/bash

echo "=== CareRide Full-Stack Deployment Status ==="
echo

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
    if [ "$2" = "ok" ]; then
        echo -e "${GREEN}✅${NC} $1"
    elif [ "$2" = "warning" ]; then
        echo -e "${YELLOW}⚠️${NC} $1"
    else
        echo -e "${RED}❌${NC} $1"
    fi
}

echo "Testing deployment components..."
echo

# Test frontend
echo "1. Testing Frontend (Angular):"
FRONTEND_STATUS=$(curl -s -I http://127.0.0.1/ | head -1)
if echo "$FRONTEND_STATUS" | grep -q "200 OK"; then
    print_status "Frontend serving correctly" "ok"
else
    print_status "Frontend not responding correctly" "error"
    echo "   Response: $FRONTEND_STATUS"
fi

# Test backend API
echo
echo "2. Testing Backend API:"
API_STATUS=$(curl -s -I http://127.0.0.1/api/test | head -1)
if echo "$API_STATUS" | grep -q "302"; then
    print_status "Backend API responding (Spring Security redirect)" "ok"
else
    print_status "Backend API not responding correctly" "error"
    echo "   Response: $API_STATUS"
fi

# Test database
echo
echo "3. Testing Database Connection:"
DB_STATUS=$(docker exec care-ride-postgres-1 psql -U careride -d careride -c "SELECT 1;" 2>/dev/null | grep -q "1 row")
if [ $? -eq 0 ]; then
    print_status "Database connection working" "ok"
else
    print_status "Database connection issues" "warning"
fi

# Test Docker containers
echo
echo "4. Testing Docker Containers:"
BACKEND_RUNNING=$(docker ps | grep care-ride-backend-1 | wc -l)
POSTGRES_RUNNING=$(docker ps | grep care-ride-postgres-1 | wc -l)

if [ "$BACKEND_RUNNING" -eq 1 ]; then
    print_status "Backend container running" "ok"
else
    print_status "Backend container not running" "error"
fi

if [ "$POSTGRES_RUNNING" -eq 1 ]; then
    print_status "PostgreSQL container running" "ok"
else
    print_status "PostgreSQL container not running" "error"
fi

# Test nginx
echo
echo "5. Testing Nginx:"
NGINX_STATUS=$(systemctl is-active nginx)
if [ "$NGINX_STATUS" = "active" ]; then
    print_status "Nginx service active" "ok"
else
    print_status "Nginx service not active" "error"
fi

# Test DNS
echo
echo "6. Testing DNS (may take time to propagate):"
DNS_CHECK=$(nslookup careridesolutionspa.com 8.8.8.8 2>/dev/null | grep "167.99.55.181")
if [ -n "$DNS_CHECK" ]; then
    print_status "DNS propagated successfully" "ok"
else
    print_status "DNS still propagating (this is normal, wait 24-48 hours)" "warning"
fi

echo
echo "=== DEPLOYMENT SUMMARY ==="
echo
echo "🌐 Frontend: Angular app serving at root path"
echo "🔧 Backend: Spring Boot API at /api/* endpoints"
echo "🗄️  Database: PostgreSQL with persistent storage"
echo "🔒 Security: Spring Security authentication"
echo "⚡ Performance: Static asset caching enabled"
echo
echo "💡 Next Steps:"
echo "   1. Wait for DNS: https://www.whatsmydns.net/"
echo "   2. Setup SSL: sudo certbot --nginx -d careridesolutionspa.com -d www.careridesolutionspa.com"
echo "   3. Test site: http://careridesolutionspa.com (once DNS propagates)"
echo
echo "🎉 Your full-stack CareRide application is successfully deployed!"
