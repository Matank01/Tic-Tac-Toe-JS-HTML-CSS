# Start from the official nginx image
FROM nginx:alpine

# Copy static site files
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80