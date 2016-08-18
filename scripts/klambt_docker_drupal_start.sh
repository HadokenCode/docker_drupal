#!/bin/bash

# WAIT FOR DATABASE
while ! mysqladmin ping -h"$MYSQL_LINK" --silent; do
    echo "Wait for Database $MYSQL_LINK:$MYSQL_PORT"
    sleep 1
done

if [ $(mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_LINK -D $MYSQL_DATABASE -P $MYSQL_PORT --execute="SHOW TABLES" -s | tail -n +1 | wc -l) -gt 2 ]; then 
  klambt_docker_update_install.sh
  else 
    klambt_docker_clean_install.sh
fi

#Write the Drupal Configuration
klambt_docker_drupal_configuration.sh

chown -R www-data:www-data /var/www/html/sites/default/files
chmod +w /var/www/html/sites/default/files
apache2-foreground