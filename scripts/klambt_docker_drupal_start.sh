#!/bin/bash

# WAIT FOR DATABASE
while ! mysqladmin ping -h"$MYSQL_LINK" --silent; do
    echo "Wait for Database $MYSQL_LINK:$MYSQL_PORT"
    sleep 1
done


echo '#############################################'
echo '#          CLEAN INSTALL DRUPAL             #'
echo '#                                           #'
echo '#                                           #'
echo '#############################################'
cd $WORKDIR
drush site-install --db-url=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_LINK:$MYSQL_PORT/$MYSQL_DATABASE --locale=$DRUPAL_LOCALE --account-name=$DRUPAL_USERNAME --account-mail=$DRUPAL_USER_MAIL --account-pass=$DRUPAL_USER_PASSWORD --site-mail=$DRUPAL_SITE_MAIL -y

drush pm-download -y $(grep -vE "^\s*#" /root/conf/drupal-7-modules.conf  | tr "\n" " ")

#enable one module at a time
while read STRING
do
  STRING=${STRING%$'\r'}
  drush pm-enable -y $STRING
  drush cache-clear drush
done < /root/conf/drupal-7-modules.conf

#Write the Drupal Configuration
klambt_docker_drupal_configuration.sh

chown -R www-data:www-data /var/www/html/sites/default/files
chmod +w /var/www/html/sites/default/files
apache2-foreground