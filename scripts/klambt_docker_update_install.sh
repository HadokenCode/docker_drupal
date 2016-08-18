#!/bin/bash
echo '#############################################'
echo '#              UPDATE DRUPAL                #'
echo '#                                           #'
echo '#                                           #'
echo '#############################################'
cd $WORKDIR
mysql -u root --password=root -h drupal_database -D drupal --execute="SELECT name FROM system WHERE type='module' AND status='1' AND filename LIKE 'sites/all/modules/%'" -s | tail -n +1 > /root/conf/drupal-installed-modules.txt
#enable one module at a time
while read STRING
do
  STRING=${STRING%$'\r'}
  drush pm-download $STRING -y
done < /root/conf/drupal-installed-modules.txt

drush cache-clear
drush pm-refresh
drush pm-updatestatus
drush pm-update -y
