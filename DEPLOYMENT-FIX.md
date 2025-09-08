# GitHub Actions SSH Configuration Fix

## Required Repository Secrets

Navigate to: https://github.com/chhabi86/care-ride/settings/secrets/actions

Add these secrets:

### SSH Configuration
- **DEPLOY_HOST**: `167.99.55.181`
- **DEPLOY_USER**: `root`
- **DEPLOY_SSH_PORT**: `22`
- **DEPLOY_DOMAIN**: `careridesolutionspa.com`

### SSH Key Setup
You need to add either:
- **DEPLOY_SSH_KEY**: Your private SSH key (the one that matches the public key on the server)
- OR **DEPLOY_SSH_KEY_B64**: Base64 encoded version of your private SSH key

## How to get your SSH key:

### Option 1: Use existing key
If you have an SSH key that works with the server:
```bash
cat ~/.ssh/id_rsa
```
Copy the entire output (including -----BEGIN and -----END lines)

### Option 2: Create new SSH key
```bash
# Generate new SSH key
ssh-keygen -t rsa -b 4096 -C "github-actions@care-ride" -f ~/.ssh/care-ride-deploy

# Copy public key to server
ssh-copy-id -i ~/.ssh/care-ride-deploy.pub root@167.99.55.181

# Get private key for GitHub secret
cat ~/.ssh/care-ride-deploy
```

### Option 3: Base64 encode key
```bash
cat ~/.ssh/id_rsa | base64 -w 0
```
Use this output for DEPLOY_SSH_KEY_B64 secret.

## Testing the fix:

After adding the secrets, trigger the deployment by:
1. Making any small change to the code
2. Committing and pushing to main branch
3. Or manually trigger from GitHub Actions tab

## Alternative: Disable Auto-Deploy

If you want to temporarily disable auto-deployment:
```bash
# Comment out the push trigger in the workflow
# Remove these lines from .github/workflows/remote-deploy.yml:
#   push:
#     branches: [ main ]
```
