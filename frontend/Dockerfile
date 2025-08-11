# Use nginx base image
FROM nginx:stable-alpine

# Install envsubst (gettext) for runtime env replacement
RUN apk add --no-cache gettext

# Create app directory in image
WORKDIR /usr/share/nginx/html

# Copy site files (index.html has placeholder __API_BASE__)
COPY index.html .
# copy optional assets folder if exists
# COPY public ./public

# Copy custom nginx config if you need (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

# Run entrypoint which substitutes env variables then starts nginx
ENTRYPOINT ["/entrypoint.sh"]
