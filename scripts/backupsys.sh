#!/bin/bash
rep="/var/www/backupsys/"
backsys="/var/www/html/"

if [[ ! -d ${rep} ]] ; then sudo mkdir ${rep}; fi
sudo chown -R vagrant:vagrant ${rep}

cp ${backsys}configuration.php ${rep}


expect -c 'spawn scp -r /var/www/backupsys/configuration.php vagrant@192.168.99.12:/var/www/backupsys/configuration.php;
expect "password:"
send "vagrant\r"
interact'

# sudo rm -r ${rep}
echo "backup system ok"