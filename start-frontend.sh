#!/bin/bash
echo "🎨 Starting CareRide Frontend (Angular)..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start Angular development server with API proxy
echo "🚀 Starting Angular frontend with API proxy..."
npm start -- --proxy-config proxy.conf.json --port 4201
