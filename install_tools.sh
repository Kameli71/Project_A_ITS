
#!/bin/bash
echo "Mise à jour du systéme"
# yum -y update

echo "installation de mon logiciel"
echo "mettre les commandes d'installation de votre logiciel (odoo, nginx, haproxy, joomla, mediawiki)"


echo "For this Stack, you will use $(ip -f inet addr show enp0s8 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"
