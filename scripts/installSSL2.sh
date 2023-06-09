#!/bin/bash

sudo yum update

sudo mkdir /vagrant/nginx/ssl
sudo mkdir /etc/ssl/privat

#creation d'une répertoire
mkdir /vagrant/ngix/ssl
sudo yum -y install openssl  openssl-devel -y
sudo yum -y install mod_ssl

#Istall package requirement pour SSL 
sudo yum install -y make gcc perl-core pcre-devel wget zlib-devel
#Télécharger la dernière version du OpenSSL
sudo wget https://ftp.openssl.org/source/openssl-1.1.1k.tar.gz
sudo tar -xzvf openssl-1.1.1k.tar.gz
sudo cd openssl-1.1.1k
sudo ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic

#Compile package
#sudo make
#sudo make test
#sudo make install

#Exporter le chemin de la bibliothèque
nano /etc/profile.d/openssl.sh
export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
source /etc/profile.d/openssl.shf

#Dans cette étape il faudra créer deux key; une publique dans /etc/ssl/certs et key pravite bien sure /etc/ssl/privaite
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
 -subj "/C=France/ST=Rhône/L=Lyon/O=Its/OU=aa/CN=commonName/emailAddress=test@example.com"
#pour renforcer la clé, on peut utiliser les groupes Diffie-Hellman
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
#Créer le TLS/SSL dans le fichier ssl.conf
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
    return 301 https://$host$request_uri;
}
EOF

sudo chmod 700 /etc/ssl/private

sudo nginx -t
sudo systemctl restart nginx