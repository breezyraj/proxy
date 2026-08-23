#!/bin/bash
# Get account ID and region from instance metadata (works on any AWS account)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
ACCOUNT_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | grep accountId | awk -F'"' '{print $4}')

ECR_BASE="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
APP_NAME="my-app-proxy"
CONTAINER_NAME="proxy"

echo "Deploying $CONTAINER_NAME (Account: $ACCOUNT_ID, Region: $REGION)"
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_BASE

docker rm -f $CONTAINER_NAME 2>/dev/null || true
docker pull $ECR_BASE/$APP_NAME:latest
docker run -d --network host --name $CONTAINER_NAME $ECR_BASE/$APP_NAME:latest
echo "$CONTAINER_NAME running (network host, port 80)"
