#!/bin/bash
#update
sudo yum update
#creation d'une répertoire
sudo mkdir /vagrant/ngix/ssl
sudo mkdir /etc/ssl/private
#install openssl
sudo yum -y install openssl mod_ssl openssl-devel -y

#Package requirement for SSL
sudo yum install -y make gcc perl-core pcre-devel wget zlib-devel -y

#Download the latest version of OpenSSL source code
sudo wget https://ftp.openssl.org/source/openssl-1.1.1k.tar.gz
tar -xzvf openssl-1.1.1k.tar.gz
cd openssl-1.1.1k
sudo ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic

# Compile package tests
# sudo make
# sudo make test
# sudo make install

#Export library path
sudo tee /etc/profile.d/openssl.sh <<- 'EOF'
export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
source /etc/profile.d/openssl.sh
EOF


#Dans cette étape il faudra créer deux key; une publique dans /etc/ssl/certs et key privée bien sure /etc/ssl/private
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
 -subj "/C=France/ST=Rhône/L=Lyon/O=Its/CN=www.joomla.com"

#Créer le TLS/SSL dans le fichier ssl.conf
# Brekdown of the commands:

#     Listen 80: This instructs the system to catch all HTTP traffic on Port 80
#     Servername ;: This will match any hostname
#     Return 301: This tells the browser (and search engines) that this is a permanent redirect
#     https://%24host%24request_uri/: This is a short code to specify the HTTPS version of whatever the user has typed

sudo tee nano /etc/nginx/conf.d/ssl.conf <<- 'EOF'
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
    return 301 https://$host$request_url;
}
EOF

sudo chmod 700 /etc/ssl/private

#Strengthen key using Diffie-Hellman Groups
# sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

sudo chmod 700 /etc/ssl/certs

#enable modifications nginx
sudo nginx -t
sudo systemctl restart nginx