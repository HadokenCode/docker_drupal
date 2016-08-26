#!/bin/bash

version=drupal-7

if [ ! -z "$1" ]; then
  version=$1
fi

cp /root/conf/000-default.conf /etc/apache2/sites-enabled/

if [ "$INSTALL_DRUPAL" = 1 ]; then
    echo '#############################################'
    echo '#            INSTALLING DRUPAL              #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  ENV INSTALL_DRUPAL=0                     #'
    echo '#                                           #'
    echo '#############################################'

    rm -rf /var/www/html/*
    drush dl $version --destination=/var/www/html
    dir=`ls -l /var/www/html | awk '{print $9}' | grep 'drupal-'`
    shopt -s dotglob
    mv $dir/* .
    rm -rf $dir

    mkdir -p /var/www/html/sites/all/modules/custom
    mkdir -p /var/www/html/sites/all/themes/custom


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