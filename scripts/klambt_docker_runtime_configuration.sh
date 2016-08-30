#!/bin/bash

echo '##############################################'
echo '#      Starting Runtime Configuration        #'
echo '#                                            #'
echo '#  This can be disabled during runtime with: #'
echo '#  -e KLAMBT_DOCKER_RUNTIME_CONFIGURATION=0  #'
echo '#                                            #'
echo '##############################################'

if [ ! "$DEBIAN_INSTALL_PACKAGES" = 0 ]; then
  klambt_docker_update_debian.sh
fi

if [ "$USE_NFS_CLIENT" = 1 ]; then
  /usr/local/bin/klambt_docker_nfs.sh
  if [ ! "$DRUPAL_FILE_NFS_DIR" = 1 ]; then
     mkdir -p /mount/drupal-nfs-data-files
     mkdir -p /tmp/local-files
     mount -t nfs $DRUPAL_FILE_NFS_DIR sites/default/files $NFS_OPTIONS
  fi
fi

mkdir -p /tmp/drupal
mkdir -p /var/www/private
chmod 777 /tmp/drupal
chown www-data:www-data /var/www/private

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

drush vset --yes less_engine less.php
drush vset --yes file_temporary_path /tmp/drupal/ 
drush vset --yes file_private_path ../private/

klambt_docker_drupal_configuration.sh

chmod +w /var/www/html/sites/default/files

echo '#############################################'
echo '#           DRUPAL CREDENTIALS              #'
echo '#                                           #'
echo '#  Login with:                              #'
echo "#  Username: $DRUPAL_USERNAME "
echo "#  Password: $DRUPAL_USER_GENERATED_PASSWORD"
echo '#                                           #'
echo '#############################################'
