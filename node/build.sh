#!/bin/bash

export DOCKER_BUILDKIT=1

# Build for Node 18
docker buildx build --platform linux/amd64,linux/arm64 --build-arg NODE_VERSION=18 -t meghsh/node:18 -f node/Dockerfile node --push

# Build for Node 20
docker buildx build --platform linux/amd64,linux/arm64 --build-arg NODE_VERSION=20 -t meghsh/node:20 -f node/Dockerfile node --push

# Build for Node 22
docker buildx build --platform linux/amd64,linux/arm64 --build-arg NODE_VERSION=22 -t meghsh/node:22 -f node/Dockerfile node --push

# Build for Node 24
docker buildx build --platform linux/amd64,linux/arm64 --build-arg NODE_VERSION=24 -t meghsh/node:24 -f node/Dockerfile node --push

# Build for Node 25
docker buildx build --platform linux/amd64,linux/arm64 --build-arg NODE_VERSION=25 -t meghsh/node:25 -f node/Dockerfile node --push
