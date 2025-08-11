# Use a small Node image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files first for caching
COPY package*.json ./

# Install deps (production only by default)
RUN npm ci --only=production

# Copy app source
COPY . .

# Create a non-root user and adjust permissions
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
  && chown -R appuser:appgroup /usr/src/app

USER appuser

# Expose port the app listens on
EXPOSE 3000

# Start the app
CMD ["node", "server.js"]