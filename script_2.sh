#!/bin/bash

# Update and install necessary dependencies
sudo yum update -y
sudo yum install -y php php-mysqlnd

# Additional setup can go here, such as:
# - Configuring the application environment
# - Installing application-specific dependencies
# - Setting up logging, monitoring, etc.

# Example: Setting up a directory for application logs
sudo mkdir -p /var/log/my_app
sudo chown -R ec2-user:ec2-user /var/log/my_app