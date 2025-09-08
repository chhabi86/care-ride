#!/bin/bash

# CareRide Local Development Startup Script
echo "🚗 Starting CareRide Local Development Environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "⚠️  Docker Desktop is not running. Please start Docker Desktop first."
    echo "   You can start it manually or run: open -a Docker"
    exit 1
fi

# Start database and backend
echo "🗄️  Starting PostgreSQL database..."
docker-compose -f docker-compose.local.yml up -d db

echo "⏳ Waiting for database to be ready..."
sleep 5

echo "🚀 Starting Spring Boot backend..."
docker-compose -f docker-compose.local.yml up -d backend

echo "⏳ Waiting for backend to start..."
sleep 10

# Start frontend
echo "🎨 Starting Angular frontend..."
cd frontend
npm start -- --port 4201 &
FRONTEND_PID=$!

echo ""
echo "✅ CareRide Local Development Environment is starting up!"
echo ""
echo "📋 Services:"
echo "   🗄️  Database:  http://localhost:5432 (PostgreSQL)"
echo "   🚀 Backend:   http://localhost:8080 (Spring Boot API)"
echo "   🎨 Frontend:  http://localhost:4201 (Angular App)"
echo ""
echo "🌐 Open your browser to: http://localhost:4201"
echo ""
echo "To stop all services:"
echo "   docker-compose -f docker-compose.local.yml down"
echo "   kill $FRONTEND_PID  # Stop frontend"
echo ""

# Wait for user input to stop
echo "Press Ctrl+C to stop all services..."
trap 'echo "🛑 Stopping services..."; docker-compose -f docker-compose.local.yml down; kill $FRONTEND_PID 2>/dev/null; exit' INT
wait
