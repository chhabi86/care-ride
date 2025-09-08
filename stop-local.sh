#!/bin/bash

# CareRide Local Development Stop Script
echo "🛑 Stopping CareRide Local Development Environment..."

# Stop Docker containers
echo "🗄️  Stopping database and backend containers..."
docker-compose -f docker-compose.local.yml down

# Kill any running Angular dev server
echo "🎨 Stopping Angular frontend..."
pkill -f "ng serve" 2>/dev/null || true
pkill -f "npx ng serve" 2>/dev/null || true

echo "✅ All CareRide local development services stopped!"
