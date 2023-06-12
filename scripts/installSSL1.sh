#!/bin/bash

sudo yum update -y
sudo mkdir /etc/ssl/private
# Installation du package requirement pour installer SSL
sudo yum -y install openssl openssl-devel mod_ssl make gcc perl-core pcre-devel wget zlib-devel

# Téléchargement et installation de OpenSSL
sudo wget https://ftp.openssl.org/source/openssl-1.1.1k.tar.gz
sudo tar -xzvf openssl-1.1.1k.tar.gz
cd openssl-1.1.1k
sudo ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic

# Export du chemin de la bibliothèque
echo 'export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64' | sudo tee /etc/profile.d/openssl.sh
source /etc/profile.d/openssl.sh

# Création des clés SSL
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
 -subj /C="FR"/ST="Rhone"/L="Lyon"/O="My Organization"/OU="My Unit"/CN="mydomain.com"/emailAddress="admin@mydomain.com"

# Création du fichier de configuration SSL
sudo tee /etc/nginx/conf.d/ssl.conf > /dev/null <<EOF
server {
    listen 443 http2 ssl;
    listen 192.168.99.10:443 http2 ssl;
    server_name nginx;

    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
}

server {
    listen 80;
    listen 192.168.99.10:80;
    server_name nginx;
    return 301 https://\$host\$request_uri;
}
EOF

# Renforcement de la clé avec Diffie-Hellman
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

sudo chmod 700 /etc/ssl/private

sudo nginx -t
sudo systemctl restart nginx

