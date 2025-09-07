# Deployment Notes

1. The file `backend/backend.env.example` is copied to `backend/backend.env` on first deploy if the latter is missing. Populate real secrets after initial run.
2. Required variables (edit in `backend/backend.env`):
   - SPRING_DATASOURCE_PASSWORD (change from default)
   - SPRING_MAIL_HOST / PORT / USERNAME / PASSWORD
   - Any JWT or security related secrets if added later.
3. After editing env file on server: `sudo docker compose up -d --force-recreate backend`.
4. TLS issuance via certbot requires the `DOMAIN` environment variable (supplied via DEPLOY_DOMAIN secret in workflow).
