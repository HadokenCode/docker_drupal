#!/bin/bash

if [ "$KLAMBT_DOCKER_RUNTIME_CONFIGURATION" = 1 ]; then
  if [ ! -f /var/www/html/sites/default/settings.php ]; then
    klambt_docker_runtime_configuration.sh
  fi 
else 
    echo '##############################################'
    echo '#  Skipping automatic Runtime Configuration  #'
    echo '#                                            #'
    echo '#  This can be enable during runtime with:   #'
    echo '#  -e KLAMBT_DOCKER_RUNTIME_CONFIGURATION=1  #'
    echo '#                                            #'
    echo '##############################################'
fi

# WAIT FOR DATABASE
while ! mysqladmin ping -h"$MYSQL_LINK" --silent; do
    echo "Wait for Database $MYSQL_LINK:$MYSQL_PORT"
    sleep 1
done

apache2-foreground