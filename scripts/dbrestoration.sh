#!/bin/bash
rep="/var/www/backupbdd/"
db="joomladb"

# if [[ ! -d ${rep}${db} ]] ; then echo "Vous n'avez aucune sauvegarde"; else mysql -u root -p --skip-password ${db} < ${rep}${db}.sql  && echo "Votre bdd a été mise à jour"; fi
function sauvegarde() {
    if [[ ! -f ${rep}${db}.sql ]] ; then
    echo "Vous n'avez aucune sauvegarde";
    else
    mysql -u root -p --skip-password ${db} < ${rep}${db}.sql
    echo "Votre bdd a été mise à jour"
    fi
    }
sauvegarde;    