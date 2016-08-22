#!/bin/bash

if [! "$DEBIAN_INSTALL_PACKAGES" = 0 ]; then
  klambt_docker_update_debian.sh
fi

# WAIT FOR DATABASE
while ! mysqladmin ping -h"$MYSQL_LINK" --silent; do
    echo "Wait for Database $MYSQL_LINK:$MYSQL_PORT"
    sleep 1
done

apache2-foreground