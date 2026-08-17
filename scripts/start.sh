#!/bin/bash
echo "Logging into ECR..."
ECR_BASE="371320329671.dkr.ecr.us-east-1.amazonaws.com"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_BASE

#Start Proxy LAST (needs UI + Backend running first)
echo "Starting Proxy on port 80..."
docker stop proxy 2>/dev/null || true
docker rm proxy 2>/dev/null || true
docker pull $ECR_BASE/my-app-proxy:latest
docker run -d --network host --name proxy $ECR_BASE/my-app-proxy:latest

echo "Containers running!"
docker ps
