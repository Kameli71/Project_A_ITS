#!/bin/bash
rep="/var/www/backupbdd/"
sudo chown -R root:root /var/www/backupbdd
# backsys="/var/www/html/"
# sudo yum install epel-release 
# sudo yum install expect 
# if [[ ! -d ${rep} ]] ; then sudo mkdir ${rep}; fi
# sudo chown -R vagrant:vagrant ${rep}
# sudo chown -R vagrant:vagrant ${backsys}
sudo mysqldump -u root -p --skip-password joomladb > ${rep}joomladb.sql 2>/dev/null
sudo chmod 777 /var/www/backupbdd/joomladb.sql

# cp -r ${backsys}* ${rep}
# expect -c 'spawn scp test5.sql vagrant@192.168.99.12:test5.sql; expect "password:"; send "vagrant\r"; interact'

# cd ${rep}

expect -c 'spawn scp /var/www/backupbdd/joomladb.sql vagrant@192.168.99.12:/var/www/backupbdd/joomladb.sql;
expect "password:"
send "vagrant\r"
interact'
# if [[ -d ${rep} ]] ; then sudo rm -r ${rep}; fi
echo "backup bdd ok"