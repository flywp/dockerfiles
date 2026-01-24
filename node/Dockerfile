ARG NODE_VERSION=18
FROM node:${NODE_VERSION}-alpine

# Install system dependencies
RUN apk add --no-cache git bash

# Install global packages and clean cache
RUN npm install -g yarn pnpm vite --force && npm cache clean --force

CMD ["node"]
