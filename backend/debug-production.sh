#!/bin/bash

echo "🚀 CareRide Production Server Diagnosis and Fix"
echo "==============================================="
echo ""
echo "This script will help diagnose and fix the production server issues."
echo ""
echo "🔧 SSH to your production server and run these commands:"
echo ""
echo "# 1. Connect to your production server"
echo "ssh root@careridesolutionspa.com"
echo ""
echo "# 2. Check if Docker containers are running"
echo "docker ps"
echo ""
echo "# 3. Check container logs"
echo "docker logs backend"
echo "docker logs db"
echo ""
echo "# 4. Check if backend.env file exists and has correct values"
echo "ls -la backend.env"
echo "cat backend.env | grep MAIL_"
echo ""
echo "# 5. Navigate to your application directory"
echo "cd /opt/care-ride  # or wherever your docker-compose.yml is located"
echo ""
echo "# 6. Create/update the backend.env file with correct email settings"
cat << 'EOF'
echo "Creating backend.env with correct settings..."
cat > backend.env << 'ENVEOF'
# Database Configuration
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/caredb
SPRING_DATASOURCE_USERNAME=careuser
SPRING_DATASOURCE_PASSWORD=changeme_db_password

# JWT Configuration (generate a secure random string for production)
JWT_SECRET=care_ride_jwt_secret_2024_production_change_me

# AWS WorkMail Configuration
MAIL_HOST=smtp.mail.us-east-1.awsapps.com
MAIL_PORT=465
MAIL_USERNAME=info@careridesolutionspa.com
MAIL_PASSWORD=Transportation1@@
MAIL_DEBUG=true

# Profile
SPRING_PROFILES_ACTIVE=prod
ENVEOF
EOF
echo ""
echo "# 7. Set proper permissions on the env file"
echo "chmod 600 backend.env"
echo ""
echo "# 8. Stop and restart all containers"
echo "docker compose down"
echo "docker compose up -d"
echo ""
echo "# 9. Wait for containers to start and check status"
echo "sleep 30"
echo "docker ps"
echo ""
echo "# 10. Check backend logs for email configuration"
echo "docker logs backend | grep -i mail"
echo "docker logs backend | grep -i email"
echo "docker logs backend | grep -i 'Started CareRideApplication'"
echo ""
echo "# 11. Test the API directly from the server"
cat << 'EOF'
curl -X POST http://localhost:8080/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Production Test",
    "email": "test@example.com",
    "phone": "1234567890",
    "reason": "Testing",
    "message": "Testing from production server"
  }'
EOF
echo ""
echo "# 12. Check nginx configuration"
echo "nginx -t"
echo "systemctl status nginx"
echo ""
echo "# 13. Check if ports are properly configured"
echo "netstat -tulpn | grep :8080"
echo "netstat -tulpn | grep :80"
echo ""
echo "🔍 Expected Results:"
echo "   - Docker containers should be running (backend, db)"
echo "   - Backend logs should show 'Started CareRideApplication'"
echo "   - API test should return: {\"emailStatus\":true,\"id\":X,\"status\":\"sent\"}"
echo "   - No errors in docker logs"
echo ""
echo "🚨 If Issues Persist:"
echo "   1. Check if the backend.env file is in the same directory as docker-compose.yml"
echo "   2. Verify Docker Compose file references backend.env correctly"
echo "   3. Check server resources (disk space, memory)"
echo "   4. Review nginx proxy configuration"
echo ""
echo "📧 After fixing, test at: https://careridesolutionspa.com/contact"
echo ""
