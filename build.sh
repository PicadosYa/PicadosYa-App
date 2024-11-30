#!/bin/bash

# Configuration
DOCKER_USERNAME="picadosya"
FRONTEND_IMAGE="picados-ya-frontend"
BACKEND_IMAGE="picados-ya-backend"
FRONTEND_TAG="latest"
BACKEND_TAG="latest"
FRONTEND_PATH="./Frontend"
BACKEND_PATH="./Backend"

# Login to Docker Hub (if required)
echo "Logging into Docker Hub..."
sudo docker login || { echo "Docker login failed. Please check your credentials."; exit 1; }

# Build Frontend Image
echo "Building frontend image..."
cd "$FRONTEND_PATH" || { echo "Frontend directory not found."; exit 1; }
sudo docker build -f Dockerfile.prod -t "$DOCKER_USERNAME/$FRONTEND_IMAGE:$FRONTEND_TAG" . || { echo "Frontend build failed."; exit 1; }
cd - || exit 1

# Build Backend Image
echo "Building backend image..."
cd "$BACKEND_PATH" || { echo "Backend directory not found."; exit 1; }
sudo docker build -f Dockerfile.prod -t "$DOCKER_USERNAME/$BACKEND_IMAGE:$BACKEND_TAG" . || { echo "Backend build failed."; exit 1; }
cd - || exit 1

# Push Frontend Image to Docker Hub
echo "Pushing frontend image to Docker Hub..."
sudo docker push "$DOCKER_USERNAME/$FRONTEND_IMAGE:$FRONTEND_TAG" || { echo "Failed to push frontend image."; exit 1; }

# Push Backend Image to Docker Hub
echo "Pushing backend image to Docker Hub..."
sudo docker push "$DOCKER_USERNAME/$BACKEND_IMAGE:$BACKEND_TAG" || { echo "Failed to push backend image."; exit 1; }

echo "Frontend and backend images have been successfully pushed to Docker Hub."
