#!/bin/bash

if [ "$INSTALL_DRUPAL" = 1 ]; then
    echo '#############################################'
    echo '#            INSTALLING DRUPAL              #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  ENV INSTALL_DRUPAL=0                     #'
    echo '#                                           #'
    echo '#############################################'

    rm -rf /var/www/html/*
    drush dl drupal-7 --destination=/var/www/html
    dir=`ls -l /var/www/html | awk '{print $9}' | grep 'drupal-'`
    shopt -s dotglob
    mv $dir/* .
    rm -rf $dir
    mkdir -p /var/www/html/sites/all/modules/custom
    mkdir -p /var/www/html/sites/all/themes/custom

    echo '#############################################'
    echo '#       Downloading DRUPAL Modules          #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  ENV INSTALL_DRUPAL=0                     #'
    echo '#                                           #'
    echo '#############################################'

    drush pm-download -y $(grep -vE "^\s*#" /root/conf/drupal-7-modules.conf  | tr "\n" " ")


if [ ! "$DRUPAL_INSTALL_MODULES" = 0 ]; then
    echo '#############################################'
    echo '#       INSTALLING DRUPAL Modules           #'
    echo '#    based on $DRUPAL_INSTALL_MODULES       #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  ENV DRUPAL_INSTALL_MODULES=0             #'
    echo '#                                           #'
    echo '#############################################'

    modules=$(echo $DRUPAL_INSTALL_MODULES | tr "," "\n")
    for module in $modules
    do
        module=${module%$'\r'}
        echo "Module $module missing ... Downloading ..."
        drush pm-download -y $module
    done

    echo 'Setting DRUPAL_INSTALL_MODULES=0';
    export DRUPAL_INSTALL_MODULES=0;
else
    echo '####################################################'
    echo '#   No DRUPAL Modules to install found in          #'
    echo '#          $DRUPAL_INSTALL_MODULES                 #'
    echo '#                                                  #'
    echo '#  This enabled during build with:                 #'
    echo '#  ENV DRUPAL_INSTALL_MODULES= xmlsitemap,varnish  #'
    echo '#                                                  #'
    echo '####################################################'
fi

    chown -R www-data:www-data /var/www
    echo '#############################################'
    echo '#           Prepare Composer                #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  ENV INSTALL_DRUPAL=0                     #'
    echo '#                                           #'
    echo '#############################################'

    mkdir -p /var/www/.composer
    mkdir -p /var/www/html/sites/default/files/composer/vendor
    mkdir -p /var/www/html/sites/all/vendor
    cd /var/www/html/sites/default/files/composer/
    composer install
    composer require facebook/facebook-instant-articles-sdk-php

    chown -R www-data:www-data /var/www/html/sites/default/files
    ln -s /var/www/html/sites/default/files/composer/vendor /var/www/html/sites/all/vendor
else
    echo '#############################################'
    echo '#          NOT INSTALLING DRUPAL            #'
    echo '#                                           #'
    echo '#  This can be enabled during build with:   #'
    echo '#  ENV INSTALL_DRUPAL=1                     #'
    echo '#                                           #'
    echo '#############################################'
fi


