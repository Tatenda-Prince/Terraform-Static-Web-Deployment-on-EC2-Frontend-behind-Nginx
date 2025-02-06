#!/bin/bash

# Update the system
yum update -y

# Install NGINX
yum install -y nginx

# Start and enable NGINX
systemctl start nginx
systemctl enable nginx

# Deploy static frontend
mkdir -p /usr/share/nginx/html
echo "<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Website</title>
</head>
<body>
    <h1>Hello,Welcome To Up The Chels Corp!</h1>
    <p>This is a static website hosted on NGINX.</p>
</body>
</html>" > /usr/share/nginx/html/index.html

# Restart NGINX to apply changes
systemctl restart nginx