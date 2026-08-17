#!/bin/bash
echo "Checking Docker installation..."
if ! command -v docker &> /dev/null; then
  echo "Installing Docker..."
  yum install -y docker
  systemctl start docker
  systemctl enable docker
else
  echo "Docker already installed."
  systemctl start docker
fi
