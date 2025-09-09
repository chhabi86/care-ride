#!/bin/bash
# Quick Production Email Fix Script
# Run this on your production server

set -e

echo "🔧 CareRide Production Email Quick Fix"
echo "====================================="

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found. Please cd to your application directory first."
    echo "Common locations: /opt/care-ride, /opt/care-ride-backend, or /root/care-ride"
    exit 1
fi

echo "✅ Found docker-compose.yml"

# Create backend.env with correct email settings
echo "📝 Creating backend.env with AWS WorkMail settings..."
cat > backend.env << 'EOF'
# Database Configuration
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/caredb
SPRING_DATASOURCE_USERNAME=careuser
SPRING_DATASOURCE_PASSWORD=changeme_db_password

# Piecewise alternative (used by application.yml fallbacks):
DB_HOST=db
DB_PORT=5432
DB_NAME=caredb
DB_USER=careuser
DB_PASS=changeme_db_password

# JWT Configuration
JWT_SECRET=CHANGE_ME_TO_RANDOM_STRING

# AWS WorkMail SMTP Configuration
MAIL_HOST=smtp.mail.us-east-1.awsapps.com
MAIL_PORT=465
MAIL_USERNAME=info@careridesolutionspa.com
MAIL_PASSWORD=Transportation1@@
MAIL_DEBUG=false
EOF

# Set secure permissions
chmod 600 backend.env
echo "✅ Created backend.env with secure permissions"

# Restart containers
echo "🔄 Restarting containers..."
docker compose down
docker compose up -d

echo "⏳ Waiting for containers to start..."
sleep 20

# Check container status
echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check if backend started successfully
echo ""
echo "🔍 Checking backend startup..."
if docker logs backend 2>&1 | grep -q "Started CareRideApplication"; then
    echo "✅ Backend started successfully!"
else
    echo "❌ Backend startup issue. Checking logs..."
    docker logs backend | tail -20
fi

# Test email configuration
echo ""
echo "📧 Testing email configuration..."
RESPONSE=$(curl -s -X POST http://localhost:8080/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Production Test",
    "email": "test@example.com", 
    "phone": "1234567890",
    "reason": "Testing",
    "message": "Production email test"
  }')

echo "API Response: $RESPONSE"

if echo "$RESPONSE" | grep -q '"emailStatus":true'; then
    echo "🎉 SUCCESS! Email functionality is working!"
    echo "You can now test at: https://careridesolutionspa.com/contact"
else
    echo "❌ Email still not working. Check backend logs:"
    docker logs backend | grep -i -A5 -B5 "EMAIL\|MAIL"
fi

echo ""
echo "🔧 If issues persist:"
echo "   1. Check backend logs: docker logs backend"
echo "   2. Verify nginx is running: systemctl status nginx"  
echo "   3. Test API directly: curl http://localhost:8080/api/contact"
echo ""
