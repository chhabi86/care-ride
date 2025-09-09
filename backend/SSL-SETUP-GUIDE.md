# SSL Certificate Setup Guide for careridesolutionspa.com

## 🔒 Quick SSL Fix Commands

**Run these commands on your production server (as root):**

```bash
# 1. Install required packages
apt update
apt install -y nginx certbot python3-certbot-nginx

# 2. Configure firewall
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# 3. Stop nginx temporarily
systemctl stop nginx

# 4. Get SSL certificate
certbot certonly --standalone -d careridesolutionspa.com -d www.careridesolutionspa.com --email admin@careridesolutionspa.com --agree-tos --non-interactive

# 5. Create proper nginx config
cat > /etc/nginx/sites-available/careridesolutionspa.com << 'EOF'
server {
    listen 80;
    server_name careridesolutionspa.com www.careridesolutionspa.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name careridesolutionspa.com www.careridesolutionspa.com;
    
    ssl_certificate /etc/letsencrypt/live/careridesolutionspa.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/careridesolutionspa.com/privkey.pem;
    
    # Frontend
    location / {
        root /var/www/html;
        try_files $uri $uri/ /index.html;
    }
    
    # Backend API
    location /api/ {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# 6. Enable the site
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/careridesolutionspa.com /etc/nginx/sites-enabled/

# 7. Test and start nginx
nginx -t
systemctl start nginx

# 8. Set up auto-renewal
echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -

# 9. Test HTTPS
curl -I https://careridesolutionspa.com/
```

## 🔍 Troubleshooting

### If certificate generation fails:
```bash
# Check DNS resolution
dig careridesolutionspa.com

# Check if ports are open
netstat -tulpn | grep :80
netstat -tulpn | grep :443

# Check logs
tail -f /var/log/letsencrypt/letsencrypt.log
```

### If nginx fails to start:
```bash
# Check configuration
nginx -t

# Check logs
journalctl -u nginx

# Check what's using port 80/443
lsof -i :80
lsof -i :443
```

## 📋 Manual Steps if Automated Script Fails:

1. **Install Certbot**: `apt install certbot python3-certbot-nginx`
2. **Stop services using port 80/443**: `systemctl stop nginx`
3. **Get certificate**: `certbot certonly --standalone -d careridesolutionspa.com`
4. **Configure nginx** with the config above
5. **Start nginx**: `systemctl start nginx`
6. **Test**: `curl -I https://careridesolutionspa.com/`

## ✅ Expected Results:

- ✅ **HTTP**: Redirects to HTTPS
- ✅ **HTTPS**: Loads with valid SSL certificate
- ✅ **Contact Form**: Works on both HTTP and HTTPS
- ✅ **Auto-renewal**: Certificate renews automatically

## 🔧 After SSL Setup:

1. Test website: `https://careridesolutionspa.com`
2. Test contact form: `https://careridesolutionspa.com/contact`
3. Verify SSL: `openssl s_client -connect careridesolutionspa.com:443`
