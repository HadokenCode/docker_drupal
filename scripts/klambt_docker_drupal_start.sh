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
drush pm-enable -y $(grep -vE "^\s*#" /root/conf/drupal-7-modules.conf  | tr "\n" " ")

#$databases = array (
#  'default' => 
#  array (
#    'default' => 
#    array (
#      'database' => 'drupal',
#      'username' => 'drupal',
#      'password' => 'drupal',
#      'host' => 'drupal_database',
#      'port' => '3306',
#      'driver' => 'mysql',
#      'prefix' => '',
#    ),
#  ),
#);


echo '# Let the Server do the work';          >> sites/default/settings.php 
echo "\$conf['css_gzip_compression'] = FALSE;" >> sites/default/settings.php 
echo "\$conf['js_gzip_compression'] = FALSE;"  >> sites/default/settings.php 

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

echo "# Proxy Config" 
echo "\$conf['reverse_proxy'] = TRUE;" >> sites/default/settings.php 
echo "#\$conf['reverse_proxy_addresses'] = array('$DRUPAL_VARNISH_SERVER');" >> sites/default/settings.php 
echo "\$conf['reverse_proxy_header'] = 'HTTP_X_CLUSTER_CLIENT_IP';" >> sites/default/settings.php 

# Varnish Config
drush vset varnish_control_terminal "$DRUPAL_VARNISH_SERVER:6082"
drush vset varnish_control_key "$DRUPAL_VARNISH_KEY"

chown -R www-data:www-data /var/www/html/sites/default/files
chmod +w /var/www/html/sites/default/files
apache2-foreground