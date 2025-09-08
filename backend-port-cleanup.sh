#!/bin/bash
# 🔧 Backend Port 8080 Cleanup Script
# Run this in your DigitalOcean console as root

set -e

echo "🔍 Backend Port 8080 Diagnostic and Cleanup"
echo "============================================"

# Step 1: Identify what's using port 8080
echo "📊 Checking what's using port 8080..."
echo ""

# Check with netstat
echo "=== netstat results ==="
netstat -tulpn | grep :8080 || echo "No processes found with netstat"
echo ""

# Check with lsof
echo "=== lsof results ==="
lsof -i :8080 || echo "No processes found with lsof"
echo ""

# Check with ss
echo "=== ss results ==="
ss -tulpn | grep :8080 || echo "No processes found with ss"
echo ""

# Step 2: Check for Java processes
echo "🔍 Checking for Java/Spring Boot processes..."
ps aux | grep java | grep -v grep || echo "No Java processes found"
echo ""

# Step 3: Check Docker containers
echo "🐳 Checking Docker containers..."
echo "=== All containers ==="
docker ps -a
echo ""
echo "=== Containers using port 8080 ==="
docker ps --filter "publish=8080" || echo "No containers publishing port 8080"
echo ""

# Step 4: Aggressive cleanup
echo "🧹 Starting aggressive cleanup..."

# Kill any process using port 8080
echo "🔫 Killing processes on port 8080..."
fuser -k 8080/tcp 2>/dev/null || echo "No processes to kill on port 8080"

# Stop ALL Docker containers
echo "🛑 Stopping ALL Docker containers..."
docker stop $(docker ps -aq) 2>/dev/null || echo "No containers to stop"

# Remove ALL Docker containers
echo "🗑️  Removing ALL Docker containers..."
docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"

# Clean up Docker networks
echo "🔗 Cleaning up Docker networks..."
docker network prune -f

# Clean up Docker volumes
echo "💾 Cleaning up Docker volumes..."
docker volume prune -f

# Clean up unused Docker images
echo "🖼️  Cleaning up unused Docker images..."
docker image prune -f

# Kill any remaining Java processes
echo "☕ Killing any Java processes..."
pkill -f java 2>/dev/null || echo "No Java processes to kill"

# Clean up any systemd services that might be using port 8080
echo "⚙️  Checking for systemd services on port 8080..."
systemctl list-units --type=service --state=running | grep -E "(spring|java|tomcat|care-ride)" || echo "No related services found"

# Step 5: Verification
echo ""
echo "✅ Cleanup completed! Verifying port 8080 is free..."
echo ""

if netstat -tulpn | grep :8080; then
    echo "❌ WARNING: Port 8080 still in use!"
    echo "Process details:"
    netstat -tulpn | grep :8080
    echo ""
    echo "Try manually killing the process ID shown above:"
    echo "kill -9 <PID>"
else
    echo "🎉 SUCCESS: Port 8080 is now free!"
fi

echo ""
echo "🚀 Backend deployment should now work!"
echo "Trigger another deployment to test."
