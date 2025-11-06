#!/bin/bash
# Update system
yum update -y

# Install Apache Web Server
yum install -y httpd

# Enable and start Apache
systemctl enable httpd
systemctl start httpd

# Create a sample web page
echo "<h1>Welcome to Terraform EC2 instance!</h1>" > /var/www/html/index.html
