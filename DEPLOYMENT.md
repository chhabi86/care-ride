# Deployment (Backend) — Docker + Elastic Beanstalk

This repository includes a Dockerfile and a GitHub Actions workflow to build the backend image, push it to ECR, and deploy to Elastic Beanstalk using a Dockerrun package.

Required AWS resources & setup
- An ECR repository (the workflow creates it if missing).
- An S3 bucket to upload the Dockerrun zip (set as `S3_BUCKET` secret).
- An Elastic Beanstalk application and environment (pre-created or created during deployment).

GitHub secrets to set
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION` (e.g., us-east-1)
- `AWS_ACCOUNT_ID`
- `S3_BUCKET` (bucket for EB source bundles)
- `EB_APPLICATION` (Elastic Beanstalk application name)
- `EB_ENVIRONMENT` (Elastic Beanstalk environment name)

High level steps to configure
1. Create an S3 bucket (for EB source bundles):
   ```bash
   aws s3 mb s3://your-eb-bucket --region us-east-1
   ```
2. Create an Elastic Beanstalk application and environment (platform: Docker):
   ```bash
   eb init -p docker --region us-east-1 your-app-name
   eb create your-env-name --single
   ```
3. Add the repository secrets to GitHub (above list).
4. Push to `main` branch; workflow will build, push image to ECR, upload Dockerrun zip, and update EB environment.

Notes
- The workflow assumes `Dockerrun.aws.json` is present and uses placeholders for `<AWS_ACCOUNT_ID>` and `<AWS_REGION>`; the workflow overwrites this by `jq` — ensure `jq` is available in the runner.
- If your application requires additional EB configuration (RDS, VPC), create those resources and set environment variables via the EB console or `.ebextensions`.
