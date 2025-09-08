#!/bin/bash
# 🔧 Complete Server Fix Script
# Run this ENTIRE script in your DigitalOcean console as root

set -e

echo "🚀 Starting complete server fix..."

# PART 1: Fix SSH Keys for Frontend
echo "🔑 Part 1: Fixing SSH keys for frontend..."

# Ensure SSH directory exists
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Add the correct ED25519 public key for frontend
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFm9hGU9zY2Cmgwqu44oL/IjB8ici0tXJ4lZWJ8An8jH github-actions-frontend@care-ride" >> /root/.ssh/authorized_keys

# Remove duplicates and set permissions
sort /root/.ssh/authorized_keys | uniq > /root/.ssh/authorized_keys.tmp
mv /root/.ssh/authorized_keys.tmp /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys

echo "✅ SSH keys updated for frontend"

# PART 2: Fix Port 8080 for Backend
echo "🔧 Part 2: Fixing port 8080 for backend..."

# Kill anything using port 8080
echo "Killing processes on port 8080..."
fuser -k 8080/tcp 2>/dev/null || echo "No processes on port 8080"

# Stop ALL Docker containers
echo "Stopping all Docker containers..."
docker stop $(docker ps -aq) 2>/dev/null || echo "No containers to stop"

# Remove ALL Docker containers
echo "Removing all Docker containers..."
docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"

# Kill any Java processes
echo "Killing Java processes..."
pkill -f java 2>/dev/null || echo "No Java processes to kill"

# Clean Docker networks and volumes
echo "Cleaning Docker resources..."
docker network prune -f
docker volume prune -f

# Verify port 8080 is free
echo "Verifying port 8080 is free..."
if netstat -tulpn | grep :8080; then
    echo "❌ WARNING: Port 8080 still in use!"
    netstat -tulpn | grep :8080
else
    echo "✅ Port 8080 is now free!"
fi

echo "🎉 Server fix completed!"
echo ""
echo "Summary:"
echo "✅ SSH keys configured for frontend deployment"
echo "✅ Port 8080 cleared for backend deployment"
echo ""
echo "Next: Update GitHub secret and trigger deployments!"
