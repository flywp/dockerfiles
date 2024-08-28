#!/bin/bash

# Set variables
DOCKER_HUB_USERNAME="meghsh"
IMAGE_NAME="openlitespeed"
OLS_VERSION="1.8.1"

# Ensure BuildKit is enabled
export DOCKER_BUILDKIT=1

# Create a new builder instance if it doesn't exist
if ! docker buildx inspect mybuilder >/dev/null 2>&1; then
    docker buildx create --name mybuilder --use
fi

# Ensure the builder is running
docker buildx inspect mybuilder --bootstrap

# Build images for each PHP version
# php_versions=("7.4" "8.1" "8.2")
php_versions=("8.2")

for php_version in "${php_versions[@]}"; do
    echo "Building image for PHP $php_version..."

    # Convert PHP version to lsphp format
    lsphp_version="lsphp${php_version//./}"

    # Build and push the image
    docker buildx build \
        --platform linux/amd64,linux/arm64 \
        --build-arg PHP_VERSION=$php_version \
        --build-arg LSPHP=$lsphp_version \
        --build-arg OLS_VERSION=$OLS_VERSION \
        -t $DOCKER_HUB_USERNAME/$IMAGE_NAME:$php_version \
        --push \
        .

    if [ $? -ne 0 ]; then
        echo "Error building image for PHP $php_version"
        exit 1
    fi

    echo "Successfully built and pushed image for PHP $php_version"
done

echo "All images have been built and pushed successfully!"
