#!/bin/bash
# Verify AWS WorkMail SMTP Connection
# This script tests the SMTP connection directly

echo "🔍 Testing AWS WorkMail SMTP Connection..."
echo "Host: smtp.mail.us-east-1.awsapps.com"
echo "Port: 465 (SSL)"
echo "Username: info@careridesolutionspa.com"
echo ""

# Test SMTP connection using telnet/nc
echo "Testing SMTP connectivity..."
timeout 10 bash -c "</dev/tcp/smtp.mail.us-east-1.awsapps.com/465" && echo "✅ Port 465 is reachable" || echo "❌ Port 465 is NOT reachable"

echo ""
echo "📧 Sending test email through API..."

# Send test email
RESPONSE=$(curl -s -X POST http://localhost:8080/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "SMTP Connection Test",
    "email": "test@example.com",
    "phone": "555-0000", 
    "reason": "Connection Verification",
    "message": "This email tests the AWS WorkMail SMTP connection. Time: '$(date)'"
  }')

echo "API Response: $RESPONSE"

if echo "$RESPONSE" | grep -q '"emailStatus":true'; then
    echo "✅ Email API responded successfully"
    echo ""
    echo "📋 Check your AWS WorkMail inbox at:"
    echo "   URL: https://careridesolutionspa.awsapps.com/mail"
    echo "   Email: info@careridesolutionspa.com"
    echo "   Password: Transportation1@@"
    echo ""
    echo "🔍 Look for email with subject: 'New Contact Form Submission: Connection Verification'"
    echo ""
    echo "If you don't see the email:"
    echo "   1. Check spam/junk folder"
    echo "   2. Wait 1-2 minutes for delivery"  
    echo "   3. Refresh your inbox"
    echo "   4. Check AWS WorkMail console for delivery logs"
else
    echo "❌ Email API failed"
    echo "Response: $RESPONSE"
fi

echo ""
echo "🏥 Backend logs (last 10 lines):"
tail -10 /Users/chhabisharma/Documents/care-ride-site/backend/backend-debug.log
