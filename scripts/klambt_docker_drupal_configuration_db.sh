#!/bin/bash
cd $WORKDIR

if [ ! -f sites/default/settings.php ]; then
    cp sites/default/default.settings.php sites/default/settings.php
    touch sites/default/only_automatic_config
  else  
    touch sites/default/local_config_available
    cp sites/default/settings.php sites/default/settings.php.original
fi

echo '#################################' >> sites/default/settings.php 
echo '#                               #' >> sites/default/settings.php 
echo '#   Automatic Config Section    #' >> sites/default/settings.php 
echo '#                               #' >> sites/default/settings.php 
echo '#################################' >> sites/default/settings.php 
echo ''  >> sites/default/settings.php 
echo 'error_reporting(0);' >> sites/default/settings.php 

# Database Config 
{ \
    echo ""; \
    echo "# Automatic Database configuration;"; \
    echo "\$databases = array ("; \
    echo "'default' =>"; \
    echo "array ("; \
    echo "        'default' =>"; \
    echo "        array ("; \
    echo "            'database' => '$MYSQL_DATABASE',"; \
    echo "            'username' => '$MYSQL_USER',"; \
    echo "            'password' => '$MYSQL_PASSWORD',"; \
    echo "            'host' => '$MYSQL_LINK',"; \
    echo "            'port' => '$MYSQL_PORT',"; \
    echo "            'driver' => 'mysql',"; \
    echo "            'prefix' => '',"; \
    echo "        ),"; \
    echo "    ),"; \
    echo ");"; \
} >> /var/www/html/sites/default/settings.php
