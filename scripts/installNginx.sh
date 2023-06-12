#!/bin/bash

# Adding the EPEL Software and Installing NGINX
sudo yum install epel-release -y
sudo yum install deltarpm -y
sudo yum update -y
sudo yum install nginx -y

# Start and enable NGINX
sudo systemctl start nginx
sudo systemctl enable nginx

# Create Load Balancer configuration
sudo tee /etc/nginx/conf.d/load_balancer.conf > /dev/null <<EOF
upstream app_servers {
    server 192.168.99.11 weight=3;
    server 192.168.99.12 backup;
}

server {
    listen 80;
    server_name joomla.example.com;

    location / {
        proxy_pass http://app_servers;
    }
}
EOF

# Restart NGINX
sudo systemctl restart nginx

# Check if Nginx is running
if sudo systemctl is-active nginx >/dev/null; then
    echo "Nginx est installer ! genix est en cours d'excusion."
else
    echo "L'installation de Nginx a échoué !"
fi