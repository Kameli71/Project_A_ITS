#!/bin/bash
# rep="/var/www/backupbdd/"
# repsys="/var/www/backupsys/"
# host=/usr/bin/hostname


# Affichage menu
echo -e "1(Sauvegarde bdd) "
echo -e "2(Restauration bdd)"
echo -e "3(Restauration configuration joomla)"
echo -e "4(Effacer anciennes sauvegardes) "
echo -e "5(Quitter)"

echo -n "Entrez votre choix : "
read CHOIX

if [[ "$CHOIX" != [1-4] ]]
    then
    echo "Choix incorrect"
    exit 1
    fi

case $CHOIX in
    1)
    source /vagrant/scripts/backupbdd.sh
    ;;
    
    2)
    source /vagrant/scripts/dbrestoration.sh
    ;;

    3)
    source /vagrant/scripts/sysrestoration.sh
    ;;

    4)
    ${rep} -type f -name "*.sql" -mtime +30 -delete
    echo "Vos sauvegardes de plus de 30 jours sont effacées"
    ;;
    
    5)
    return
    ;;

    *)
    echo "Choix incorrect"
        ;;
esac