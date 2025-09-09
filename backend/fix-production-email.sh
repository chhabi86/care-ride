#!/bin/bash

echo "🚀 CareRide Production Email Configuration Update"
echo "================================================"
echo ""
echo "This script will update the production environment to enable email functionality."
echo ""
echo "🔧 Steps to fix email in production:"
echo ""
echo "1️⃣  SSH to your production server:"
echo "   ssh root@careridesolutionspa.com"
echo ""
echo "2️⃣  Navigate to the backend directory:"
echo "   cd /opt/care-ride/backend"  # or wherever your app is deployed
echo ""
echo "3️⃣  Create/update the backend.env file:"
cat << 'EOF'
# Database Configuration
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/caredb
SPRING_DATASOURCE_USERNAME=careuser
SPRING_DATASOURCE_PASSWORD=changeme_db_password

# JWT Configuration
JWT_SECRET=CHANGE_ME_TO_RANDOM_STRING

# AWS WorkMail Configuration
MAIL_HOST=smtp.mail.us-east-1.awsapps.com
MAIL_PORT=465
MAIL_USERNAME=info@careridesolutionspa.com
MAIL_PASSWORD=Transportation1@@
MAIL_DEBUG=false

# Profile
SPRING_PROFILES_ACTIVE=prod
EOF
echo ""
echo "4️⃣  Save the above content to backend.env, then restart the containers:"
echo "   docker compose down"
echo "   docker compose up -d"
echo ""
echo "5️⃣  Test the email functionality:"
echo "   Check the logs: docker logs backend"
echo "   Visit: https://careridesolutionspa.com/contact"
echo ""
echo "🔒 Security Note:"
echo "   The backend.env file contains sensitive information."
echo "   Make sure it has proper permissions: chmod 600 backend.env"
echo ""
echo "📧 Expected Result:"
echo "   Contact form submissions should now send emails to info@careridesolutionspa.com"
echo ""
