#!/bin/bash

if [! "$DEBIAN_INSTALL_PACKAGES" = 0 ]; then
  klambt_docker_update_debian.sh
fi

# WAIT FOR DATABASE
while ! mysqladmin ping -h"$MYSQL_LINK" --silent; do
    echo "Wait for Database $MYSQL_LINK:$MYSQL_PORT"
    sleep 1
done

if [ $(mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_LINK -D $MYSQL_DATABASE -P $MYSQL_PORT --execute="SHOW TABLES" -s | tail -n +1 | wc -l) -gt 2 ]; then 
  klambt_docker_drupal_configuration_db.sh
  klambt_docker_update_install.sh
  else 
    klambt_docker_clean_install.sh
fi

klambt_docker_drupal_configuration.sh

chown -R www-data:www-data /var/www/html/sites/default/files
chmod +w /var/www/html/sites/default/files



echo '#############################################'
echo '#           DRUPAL CREDENTIALS              #'
echo '#                                           #'
echo '#  Login with:                              #'
echo "#  Username: $DRUPAL_USERNAME "
echo "#  Password: $DRUPAL_USER_PASSWORD"
echo '#                                           #'
echo '#############################################'

apache2-foreground