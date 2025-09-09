#!/bin/bash
# Simple script to test email functionality locally
# Sets the local profile and tests the email API

echo "🔄 Starting backend with local profile..."

# Kill any process on port 8080
lsof -ti:8080 | xargs kill -9 2>/dev/null || echo "No process on port 8080"

# Start backend in background with local profile
cd /Users/chhabisharma/Documents/care-ride-site/backend
nohup mvn spring-boot:run -Dspring-boot.run.profiles=local > backend-local.log 2>&1 &
BACKEND_PID=$!

echo "Backend PID: $BACKEND_PID"
echo "Waiting for backend to start..."

# Wait for backend to be ready
for i in {1..30}; do
    if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
        echo "✅ Backend is ready!"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 2
done

# Test if backend is ready
if ! curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
    echo "❌ Backend failed to start. Check backend-local.log"
    cat backend-local.log | tail -20
    exit 1
fi

echo ""
echo "📧 Testing email functionality..."

# Test email API
RESPONSE=$(curl -s -X POST http://localhost:8080/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Email Test",
    "email": "bajgain99@yahoo.com",
    "phone": "2148287716",
    "reason": "Testing AWS WorkMail",
    "message": "This is a test email from local development environment"
  }')

echo "API Response: $RESPONSE"

if echo "$RESPONSE" | grep -q '"emailStatus":true'; then
    echo "✅ SUCCESS! Email sent successfully!"
    echo "🎯 Check your email at bajgain99@yahoo.com"
    echo ""
    echo "📊 Email Details:"
    echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
else
    echo "❌ Email failed to send. Response:"
    echo "$RESPONSE"
    echo ""
    echo "📋 Backend logs (last 20 lines):"
    tail -20 backend-local.log
fi

echo ""
echo "🔧 Backend is running on http://localhost:8080"
echo "📋 To view logs: tail -f backend-local.log"
echo "🛑 To stop backend: kill $BACKEND_PID"
