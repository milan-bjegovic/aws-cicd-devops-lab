#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

AWS_REGION="eu-central-1"
AWS_ACCOUNT_ID="303974373642"
ECR_REPOSITORY="aws-cicd-devops-lab"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE="${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"

# Update packages
apt-get update -y

# Install required packages
apt-get install -y \
  docker.io \
  nginx \
  awscli \
  curl

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Authenticate Docker to Amazon ECR using the EC2 IAM role
aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login \
      --username AWS \
      --password-stdin "${ECR_REGISTRY}"

# Pull the latest application image
docker pull "${IMAGE}"

# Remove an existing container if present
docker rm -f cicd-backend || true

# Start application container
docker run -d \
  --name cicd-backend \
  --restart unless-stopped \
  -p 3001:3000 \
  "${IMAGE}"

# Configure Nginx as reverse proxy
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    location / {
        proxy_pass http://127.0.0.1:3001;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Validate Nginx configuration
nginx -t

# Enable and restart Nginx
systemctl enable nginx
systemctl restart nginx

# Wait for application startup
for i in {1..30}; do
  if curl -fsS http://127.0.0.1:3001/health; then
    echo "Application is healthy"
    exit 0
  fi

  sleep 2
done

echo "Application failed health check"
docker logs cicd-backend || true
exit 1