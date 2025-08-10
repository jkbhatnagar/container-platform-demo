# Use an official Node runtime as a parent image
FROM node:20-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json package-lock.json* ./
RUN npm ci --production

# Bundle app source
COPY . .

# Expose the port your app listens on
ENV PORT=3000
EXPOSE 3000

# Start the app
CMD ["node", "server.js"]
