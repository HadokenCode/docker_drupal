#!/bin/bash
echo '#############################################'
echo '#          CLEAN INSTALL DRUPAL             #'
echo '#                                           #'
echo '#                                           #'
echo '#############################################'
cd $WORKDIR

if [ "$DRUPAL_USER_PASSWORD" = 0 ]; then
   DRUPAL_USER_GENERATED_PASSWORD=$(openssl rand -base64 10 | head -c${1:-14})
   echo "Admin Password: $DRUPAL_USER_GENERATED_PASSWORD"
   export DRUPAL_USER_PASSWORD=$DRUPAL_USER_GENERATED_PASSWORD
fi

drush site-install --db-url=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_LINK:$MYSQL_PORT/$MYSQL_DATABASE --locale=$DRUPAL_LOCALE --account-name=$DRUPAL_USERNAME --account-mail=$DRUPAL_USER_MAIL --account-pass=$DRUPAL_USER_PASSWORD --site-mail=$DRUPAL_SITE_MAIL -y

klambt_docker_pull_custom.sh

if [ -f /root/conf/drupal-7-modules.conf ]; then
  #enable one module at a time
  while read STRING
  do
    STRING=${STRING%$'\r'}
    klambt_docker_drupal_module_download.sh $STRING
    klambt_docker_drupal_module_enable.sh $STRING
  done < /root/conf/drupal-7-modules.conf
fi

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
        klambt_docker_drupal_module_download.sh $module
        klambt_docker_drupal_module_enable.sh $module
    done
   
else
    echo '####################################################'
    echo '#   No DRUPAL Modules to install found in          #'
    echo '#          $DRUPAL_INSTALL_MODULES                 #'
    echo '#                                                  #'
    echo '#  This enabled during runtime with:               #'
    echo '#  -e "DRUPAL_INSTALL_MODULES=xmlsitemap,varnish"  #'
    echo '#                                                  #'
    echo '####################################################'
fi
