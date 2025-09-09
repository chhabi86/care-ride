#!/bin/bash
# Production Email Fix - Complete Instructions
# Run this on your production server

echo "🚀 Care Ride Production Email Fix"
echo "=================================="
echo ""
echo "📋 Follow these steps to fix production email:"
echo ""

echo "1️⃣ SSH to your production server:"
echo "   ssh root@careridesolutionspa.com"
echo "   # or wherever your server is hosted"
echo ""

echo "2️⃣ Navigate to your application directory:"
echo "   cd /opt/care-ride"
echo "   # or wherever your docker-compose.yml is located"
echo ""

echo "3️⃣ Pull the latest code changes:"
echo "   git pull origin main"
echo ""

echo "4️⃣ Update backend.env with correct email password:"
echo "   nano backend.env"
echo ""
echo "   Make sure it contains:"
echo "   # AWS WorkMail Configuration"
echo "   MAIL_HOST=smtp.mail.us-east-1.awsapps.com"
echo "   MAIL_PORT=465"
echo "   MAIL_USERNAME=info@careridesolutionspa.com"
echo "   MAIL_PASSWORD=Transportation1@@"
echo "   MAIL_DEBUG=true"
echo ""

echo "5️⃣ Restart the containers:"
echo "   docker compose down"
echo "   docker compose up -d"
echo ""

echo "6️⃣ Wait for containers to start (30 seconds):"
echo "   sleep 30"
echo ""

echo "7️⃣ Check container status:"
echo "   docker ps"
echo ""

echo "8️⃣ Test the email functionality:"
echo "   curl -X POST http://localhost:8080/api/contact \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{"
echo "       \"name\": \"Production Test\","
echo "       \"email\": \"test@example.com\","
echo "       \"phone\": \"555-1234\","
echo "       \"reason\": \"Email Test\","
echo "       \"message\": \"Testing production email\""
echo "     }'"
echo ""

echo "9️⃣ Verify the response:"
echo "   Should return: {\"emailStatus\":true,\"id\":X,\"status\":\"sent\"}"
echo ""

echo "🔟 Test from website:"
echo "   Visit: https://careridesolutionspa.com/contact"
echo "   Fill form and click Send Now"
echo ""

echo "📧 Check your AWS WorkMail inbox:"
echo "   URL: https://careridesolutionspa.awsapps.com/mail"
echo "   Email: info@careridesolutionspa.com"
echo "   Password: Transportation1@@"
echo ""

echo "🔍 If issues persist, check logs:"
echo "   docker logs backend"
echo "   docker logs frontend"
echo "   docker logs nginx"
echo ""

echo "✅ After successful setup, your contact form will send emails to:"
echo "   info@careridesolutionspa.com (your AWS WorkMail inbox)"
