#!/bin/bash
echo "Stopping old containers..."
docker stop proxy 2>/dev/null || true
docker rm proxy 2>/dev/null || true
echo "Old containers removed."