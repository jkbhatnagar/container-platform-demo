#!/bin/sh
set -e

# Default API base if not provided
: "${API_BASE:=http://complaints-backend-service:80/complaints}"

# Replace placeholder in index.html if template exists
if [ -f /usr/share/nginx/html/index.html ]; then
  echo "Substituting API_BASE into index.html"
  # Create temp copy and do replacement
  sed "s|__API_BASE__|${API_BASE}|g" /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.html.tmp
  mv /usr/share/nginx/html/index.html.tmp /usr/share/nginx/html/index.html
fi

# Start nginx in foreground
exec nginx -g 'daemon off;'
