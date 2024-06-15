#!/bin/bash

# Update and install Apache and PHP
sudo yum update -y
sudo yum install -y httpd php php-mysqlnd

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Download and install WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo mv wordpress/* /var/www/html/

# Set permissions
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

# Create WordPress configuration file
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Restart Apache to apply changes
sudo systemctl restart httpd
