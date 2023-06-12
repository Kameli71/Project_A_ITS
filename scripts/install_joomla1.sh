#!/bin/bash

JUSERNAME="admin"
JUSEREMAIL="admin@localhost.com"
JUSERPASS=""
DB="joomladb"
DBUSER="admin"
DBPASS="admin"


new_disk=$(sudo fdisk -l | grep -i "/dev/sd" | awk '{print $2}' | grep -v "/dev/sda" | head -n1)
sudo pvcreate "$new_disk"
sudo vgcreate volgrp01 "$new_disk"
sudo lvcreate -n lv01 -l 100%FREE volgrp01
sudo mkfs.ext4 /dev/volgrp01/lv01
sudo mkdir /var/www/html
sudo mount /dev/volgrp01/lv01 /var/www/html
echo "/dev/volgrp01/lv01   /var/www/html   ext4   defaults   0   0" | sudo tee -a /etc/fstab
sudo yum -y update
sudo yum install httpd mariadb mariadb-server php php-mysql -y
sudo yum install gcc kernel-devel make -y #Permet d'optimiser le lancement de vagrant
sudo yum install nano unzip -y
sudo yum install epel-release -y
sudo yum install expect -y
sudo systemctl start mariadb

# Créer la base de données et l'utilisateur
echo "CREATE DATABASE ${DB}" | mysql -u root --password=
echo "CREATE USER '${DBUSER}'@'localhost' IDENTIFIED BY '${DBPASS}';" | mysql -u root --password=
echo "GRANT ALL ON ${DB}.* TO '${DBUSER}'@'%';" | mysql -u root --password=
cat installation/sql/mysql/joomla.sql | mysql -u $DBUSER --password=$DBPASS $DB

# Télécharger et extraire Joomla
sudo wget https://downloads.joomla.org/cms/joomla3/3-9-16/Joomla_3-9-16-Stable-Full_Package.zip
sudo unzip Joomla_3-9-16-Stable-Full_Package.zip -d /var/www/html
sudo chmod 755 /var/www/html
sudo chown -R vagrant:vagrant /var/www/

# Configurer Apache pour Joomla
sudo tee /etc/httpd/conf.d/joomla.conf <<- 'EOF'
<VirtualHost *:80>
     ServerAdmin admin@example.com
     DocumentRoot "/var/www/html"
     ServerName joomla.example.com
     ErrorLog "/var/log/httpd/example.com-error_log"
     CustomLog "/var/log/httpd/example.com-access_log" combined

<Directory "/var/www/html">
     DirectoryIndex index.html index.php
     Options FollowSymLinks
     AllowOverride All
     Require all granted
</Directory>
</VirtualHost>
EOF

sudo rm -f Joomla_3-9-16-Stable-Full_Package.zip
systemctl restart httpd

# Créer les dossiers de sauvegarde
sudo mkdir /var/www/backupbdd
sudo mkdir /var/www/backupsys
sudo chown -R vagrant:vagrant /var/www/

# Configurer les permissions des dossiers de sauvegarde
sudo chmod 755 /var/www/backupbdd
sudo chmod 755 /var/www/backupsys

# Redémarrer Apache
sudo systemctl restart httpd

# Afficher l'adresse IP de la machine
echo "Pour cette installation, vous utiliserez l'adresse IP : $(ip -f inet addr show enp0s8 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')"

#creation de cron
(crontab -l 2>/dev/null ; echo "0 0 1 * * cd /vagrant && bash backupbdd.sh") | sudo crontab - && echo "Cron pour backupbdd.sh ajouté avec succès."
(crontab -l 2>/dev/null ; echo "0 0 1 */3 * cd /vagrant && bash backupsys.sh") | sudo crontab - && echo "Cron pour backupsys.sh ajouté avec succès."
