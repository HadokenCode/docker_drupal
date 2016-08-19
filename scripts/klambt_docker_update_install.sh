#!/bin/bash
echo '#############################################'
echo '#              UPDATE DRUPAL                #'
echo '#                                           #'
echo '#                                           #'
echo '#############################################'

cd $WORKDIR
mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -h $MYSQL_LINK -P $MYSQL_PORT -D $MYSQL_DATABASE --execute="SELECT name FROM system WHERE type='module' AND status='1' AND filename LIKE 'sites/all/modules/%'" -s | tail -n +1 > /root/conf/drupal-installed-modules.txt
#enable one module at a time
while read STRING
do
  STRING=${STRING%$'\r'}
  drush pm-download $STRING -y
done < /root/conf/drupal-installed-modules.txt


if [ "$DRUPAL_MEMCACHE_SERVER" != 0 ]; then
  echo '#############################################'
  echo '#              ENABLE MEMCACHE              #'
  echo '#                                           #'
  echo '#                                           #'
  echo '#############################################'
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
  drush pm-enable memcache
fi

if [ "$DRUPAL_VARNISH_SERVER" != 0 ]; then
  echo '#############################################'
  echo '#              ENABLE VARNISH               #'
  echo '#                                           #'
  echo '#                                           #'
  echo '#############################################'
  drush pm-enable varnish expire
fi

drush cache-clear all
drush pm-refresh
drush pm-updatestatus
drush pm-update -y
