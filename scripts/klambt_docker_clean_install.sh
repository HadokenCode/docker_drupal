#!/bin/bash
echo '#############################################'
echo '#          CLEAN INSTALL DRUPAL             #'
echo '#                                           #'
echo '#                                           #'
echo '#############################################'
cd $WORKDIR

if [ "$DRUPAL_USER_PASSWORD" = 0 ]; then
  export DRUPAL_USER_PASSWORD=$(openssl rand -base64 10 | head -c${1:-14})
fi

drush site-install --db-url=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_LINK:$MYSQL_PORT/$MYSQL_DATABASE --locale=$DRUPAL_LOCALE --account-name=$DRUPAL_USERNAME --account-mail=$DRUPAL_USER_MAIL --account-pass=$DRUPAL_USER_PASSWORD --site-mail=$DRUPAL_SITE_MAIL -y
drush pm-download -y $(grep -vE "^\s*#" /root/conf/drupal-7-modules.conf  | tr "\n" " ")

#enable one module at a time
while read STRING
do
  STRING=${STRING%$'\r'}
  drush pm-enable -y $STRING
  drush cache-clear drush
done < /root/conf/drupal-7-modules.conf

if [ ! "$DRUPAL_INSTALL_MODULES" = 0 ]; then
    echo '#############################################'
    echo '#       INSTALLING DRUPAL Modules           #'
    echo '#    based on $DRUPAL_INSTALL_MODULES       #'
    echo '#                                           #'
    echo '#  This can be disabled during runtime with:#'
    echo '#  -e "DRUPAL_INSTALL_MODULES=0"            #'
    echo '#                                           #'
    echo '#############################################'

    modules=$(echo $DRUPAL_INSTALL_MODULES | tr "," "\n")
    for module in $modules
    do
        module=${module%$'\r'}
        echo "Module $module missing ... Downloading ..."
        drush pm-download -y $module
        echo "Enable $module"
        drush pm-enable -y $module
        drush cache-clear drush
    done
   
else
    echo '####################################################'
    echo '#   No DRUPAL Modules to install found in          #'
    echo '#          $DRUPAL_INSTALL_MODULES                 #'
    echo '#                                                  #'
    echo '#  This enabled during runtime with:               #'
    echo '#  -e "DRUPAL_INSTALL_MODULES='xmlsitemap,varnish" #'
    echo '#                                                  #'
    echo '####################################################'
fi
