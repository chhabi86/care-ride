#!/bin/bash

# SSH Key Setup Helper for GitHub Actions Deployment
echo "🔑 CareRide GitHub Actions SSH Setup Helper"
echo "=========================================="
echo ""

# Check if we can connect to the server
echo "Testing current SSH access to deployment server..."
if ssh -o ConnectTimeout=5 -o BatchMode=yes root@167.99.55.181 exit 2>/dev/null; then
    echo "✅ SSH access working! Getting your current private key..."
    echo ""
    echo "🔑 Your SSH Private Key (for DEPLOY_SSH_KEY secret):"
    echo "Copy this ENTIRE output to GitHub Secrets:"
    echo "=================================================="
    cat ~/.ssh/id_rsa 2>/dev/null || cat ~/.ssh/id_ed25519 2>/dev/null || echo "❌ No SSH key found in standard locations"
    echo "=================================================="
    echo ""
    echo "OR as Base64 (for DEPLOY_SSH_KEY_B64 secret):"
    echo "=============================================="
    cat ~/.ssh/id_rsa 2>/dev/null | base64 | tr -d '\n' || cat ~/.ssh/id_ed25519 2>/dev/null | base64 | tr -d '\n' || echo "❌ No SSH key found"
    echo ""
    echo "=============================================="
else
    echo "❌ SSH access not working. Let's create a new key pair..."
    echo ""
    
    # Generate new SSH key
    SSH_KEY_PATH="$HOME/.ssh/care-ride-deploy"
    echo "🔑 Generating new SSH key pair..."
    ssh-keygen -t ed25519 -C "github-actions@care-ride" -f "$SSH_KEY_PATH" -N ""
    
    echo ""
    echo "📋 Copy this public key to your server:"
    echo "======================================="
    cat "$SSH_KEY_PATH.pub"
    echo "======================================="
    echo ""
    echo "Run this command on your server (167.99.55.181):"
    echo "echo '$(cat "$SSH_KEY_PATH.pub")' >> ~/.ssh/authorized_keys"
    echo ""
    echo "🔑 Your Private Key (for GitHub Secrets):"
    echo "========================================="
    cat "$SSH_KEY_PATH"
    echo "========================================="
    echo ""
    echo "OR as Base64:"
    echo "============"
    cat "$SSH_KEY_PATH" | base64 | tr -d '\n'
    echo ""
    echo "============"
fi

echo ""
echo "📝 GitHub Repository Secrets to Configure:"
echo "==========================================="
echo "Go to: https://github.com/chhabi86/care-ride/settings/secrets/actions"
echo ""
echo "Add these secrets:"
echo "- DEPLOY_HOST: 167.99.55.181"
echo "- DEPLOY_USER: root"
echo "- DEPLOY_SSH_PORT: 22"
echo "- DEPLOY_DOMAIN: careridesolutionspa.com"
echo "- DEPLOY_SSH_KEY: [paste the private key from above]"
echo ""
echo "🔄 After adding secrets, re-enable auto-deployment by editing:"
echo ".github/workflows/remote-deploy.yml"
echo "Uncomment the push trigger section"
echo ""
