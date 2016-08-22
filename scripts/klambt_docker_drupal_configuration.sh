#!/bin/bash
cd $WORKDIR
sleep 10

echo ''  
echo '#################################'
echo '#                               #'
echo '#      Start Writing Config     #'
echo '#                               #'
echo '#################################'
echo ''  

if [ ! -f sites/default/settings.php ]; then
  echo "using default settings as template"
  cp sites/default/default.settings.php sites/default/settings.php
fi

if [ -f sites/default/only_automatic_config ]; then
  echo "reverting interim config"
  cp sites/default/default.settings.php sites/default/settings.php
  rm sites/default/only_automatic_config
fi

if [ -f sites/default/local_config_available ]; then
  echo "switch config back"
  mv sites/default/settings.php.original sites/default/settings.php
  rm sites/default/local_config_available
fi

echo '#################################' >> sites/default/settings.php 
echo '#                               #' >> sites/default/settings.php 
echo '#   Automatic Config Section    #' >> sites/default/settings.php 
echo '#                               #' >> sites/default/settings.php 
echo '#################################' >> sites/default/settings.php 
echo ''  >> sites/default/settings.php 

echo '# Security '  >> sites/default/settings.php 
echo "\$conf['allow_authorize_operations'] = FALSE;" >> sites/default/settings.php 
echo "\$update_free_access = FALSE;" >> sites/default/settings.php 

echo '# Let the Server do the work'          >> sites/default/settings.php 
echo "\$conf['css_gzip_compression'] = FALSE;" >> sites/default/settings.php 
echo "\$conf['js_gzip_compression'] = FALSE;"  >> sites/default/settings.php 

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

if [ "$DRUPAL_MEMCACHE_SERVER" != 0 ]; then
# Memcache Config
    { \
        echo ''; \
        echo '# Automatic Memcache configuration'; \
        echo '$conf["cache_backends"][] = "sites/all/modules/memcache/memcache.inc";'; \
        echo '#$conf["lock_inc"] = "sites/all/modules/memcache/memcache-lock.inc";'; \
        echo '#$conf["memcache_stampede_protection"] = TRUE;'; \
        echo '$conf["cache_default_class"] = "MemCacheDrupal";'; \
        echo '$conf["cache_class_cache_form"] = "DrupalDatabaseCache";'; \
        echo '$conf["memcache_servers"] = array("'$DRUPAL_MEMCACHE_SERVER:11211'" => "default");'; \
    } >> /var/www/html/sites/default/settings.php
fi

if [ "$DRUPAL_VARNISH_SERVER" != 0 ]; then
    echo ''  >> sites/default/settings.php 
    echo "# Proxy Config"  >> sites/default/settings.php 
    echo "\$conf['reverse_proxy'] = TRUE;" >> sites/default/settings.php 
    echo "#\$conf['reverse_proxy_addresses'] = array('$DRUPAL_VARNISH_SERVER');" >> sites/default/settings.php 
    echo "\$conf['reverse_proxy_header'] = 'HTTP_X_CLUSTER_CLIENT_IP';" >> sites/default/settings.php 
fi



if [ "$DRUPAL_VARNISH_SERVER" != 0 ]; then
    echo ''  
    echo '#################################'
    echo '#                               #'
    echo '# Configure Drupal for Varnish  #'
    echo '#                               #'
    echo '#################################'
    echo ''  

    # Varnish Drush Config
    drush vset varnish_control_terminal "$DRUPAL_VARNISH_SERVER:6082"
    drush vset varnish_control_key "$DRUPAL_VARNISH_KEY"
fi