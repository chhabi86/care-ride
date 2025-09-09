#!/bin/bash
# Production Server Diagnosis and Fix Script
# Run this on your production server to diagnose and fix email issues

echo "🔍 Care Ride Production Email Diagnosis"
echo "======================================="
echo ""

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found. Please cd to your application directory first."
    echo "Common locations:"
    echo "   cd /opt/care-ride"
    echo "   cd /root/care-ride"
    echo "   cd /home/ubuntu/care-ride"
    exit 1
fi

echo "✅ Found docker-compose.yml"
echo ""

echo "📊 Current Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "🔍 Checking backend container logs:"
if docker ps | grep -q backend; then
    echo "Backend container is running. Last 20 log lines:"
    docker logs backend --tail=20
else
    echo "❌ Backend container is not running!"
    echo ""
    echo "🔍 Checking why backend failed to start:"
    docker logs backend --tail=50
fi
echo ""

echo "📁 Checking backend.env file:"
if [ -f "backend.env" ]; then
    echo "✅ backend.env exists"
    echo "Current email configuration:"
    grep -E "MAIL_|EMAIL_" backend.env || echo "No email configuration found"
else
    echo "❌ backend.env file missing!"
    echo "Creating backend.env with correct settings..."
    
    cat > backend.env << 'EOF'
# Database Configuration
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/caredb
SPRING_DATASOURCE_USERNAME=careuser
SPRING_DATASOURCE_PASSWORD=changeme_db_password

# Piecewise alternative
DB_HOST=db
DB_PORT=5432
DB_NAME=caredb
DB_USER=careuser
DB_PASS=changeme_db_password

# JWT Configuration
JWT_SECRET=care_ride_jwt_secret_production_2024_change_me

# AWS WorkMail SMTP Configuration
MAIL_HOST=smtp.mail.us-east-1.awsapps.com
MAIL_PORT=465
MAIL_USERNAME=info@careridesolutionspa.com
MAIL_PASSWORD=Transportation1@@
MAIL_DEBUG=false
EOF
    
    chmod 600 backend.env
    echo "✅ Created backend.env with email configuration"
fi
echo ""

echo "🔧 Fixing email configuration..."
# Ensure email configuration is correct
if ! grep -q "MAIL_PASSWORD=Transportation1@@" backend.env; then
    echo "Updating MAIL_PASSWORD..."
    sed -i 's/MAIL_PASSWORD=.*/MAIL_PASSWORD=Transportation1@@/' backend.env || echo "MAIL_PASSWORD=Transportation1@@" >> backend.env
fi

if ! grep -q "MAIL_HOST=smtp.mail.us-east-1.awsapps.com" backend.env; then
    echo "Updating MAIL_HOST..."
    sed -i 's/MAIL_HOST=.*/MAIL_HOST=smtp.mail.us-east-1.awsapps.com/' backend.env || echo "MAIL_HOST=smtp.mail.us-east-1.awsapps.com" >> backend.env
fi

if ! grep -q "MAIL_PORT=465" backend.env; then
    echo "Updating MAIL_PORT..."
    sed -i 's/MAIL_PORT=.*/MAIL_PORT=465/' backend.env || echo "MAIL_PORT=465" >> backend.env
fi

if ! grep -q "MAIL_USERNAME=info@careridesolutionspa.com" backend.env; then
    echo "Updating MAIL_USERNAME..."
    sed -i 's/MAIL_USERNAME=.*/MAIL_USERNAME=info@careridesolutionspa.com/' backend.env || echo "MAIL_USERNAME=info@careridesolutionspa.com" >> backend.env
fi

echo "✅ Email configuration updated"
echo ""

echo "🔄 Restarting containers..."
docker compose down
sleep 5
docker compose up -d

echo "⏳ Waiting for containers to start..."
sleep 30

echo ""
echo "📊 New Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "🔍 Checking backend startup:"
if docker ps | grep -q backend; then
    echo "✅ Backend container is now running"
    echo "Recent backend logs:"
    docker logs backend --tail=10
else
    echo "❌ Backend container still not running!"
    echo "Backend error logs:"
    docker logs backend --tail=30
    exit 1
fi
echo ""

echo "🧪 Testing email functionality..."
sleep 10

RESPONSE=$(curl -s -X POST http://localhost:8080/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Production Email Test",
    "email": "test@example.com",
    "phone": "555-0123",
    "reason": "Production Test",
    "message": "Testing production email after fix - should go to info@careridesolutionspa.com"
  }' || echo "API_ERROR")

echo "API Response: $RESPONSE"

if echo "$RESPONSE" | grep -q '"emailStatus":true'; then
    echo ""
    echo "🎉 SUCCESS! Production email is now working!"
    echo ""
    echo "✅ Your contact form should now work at:"
    echo "   https://careridesolutionspa.com/contact"
    echo ""
    echo "📧 Emails will be delivered to:"
    echo "   https://careridesolutionspa.awsapps.com/mail"
    echo "   Username: info@careridesolutionspa.com"
    echo "   Password: Transportation1@@"
    echo ""
else
    echo ""
    echo "❌ Email still not working. Checking backend logs for errors:"
    docker logs backend | grep -i -A10 -B10 "email\|mail\|smtp\|error" | tail -20
    echo ""
    echo "🔍 Additional debugging steps:"
    echo "1. Check if backend.env is being loaded:"
    echo "   docker exec backend env | grep MAIL"
    echo ""
    echo "2. Check backend application logs:"
    echo "   docker logs backend -f"
    echo ""
    echo "3. Verify database connection:"
    echo "   docker logs db"
fi

echo ""
echo "🔧 Quick Manual Test Commands:"
echo "  # Test API directly:"
echo "  curl -X POST http://localhost:8080/api/contact -H 'Content-Type: application/json' -d '{\"name\":\"Test\",\"email\":\"test@example.com\",\"phone\":\"555\",\"reason\":\"Test\",\"message\":\"Test\"}'"
echo ""
echo "  # Check container logs:"
echo "  docker logs backend"
echo "  docker logs frontend"
echo "  docker logs nginx"
