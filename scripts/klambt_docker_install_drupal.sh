#!/bin/bash

if [ "$INSTALL_DRUPAL" = 1 ]; then
    echo '#############################################'
    echo '#            INSTALLING DRUPAL              #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  -e "INSTALL_DRUPAL=0"                    #'
    echo '#                                           #'
    echo '#############################################'

    rm -rf /var/www/html/*
    drush dl drupal-7 --destination=/var/www/html
    dir=`ls -l /var/www/html | awk '{print $9}' | grep 'drupal-'`
    shopt -s dotglob
    mv $dir/* .
    rm -rf $dir
    chown -R www-data:www-data /var/www/html
    drush pm-download -y $(grep -vE "^\s*#" /root/conf/drupal-7-modules.conf  | tr "\n" " ")

    cd /tmp/
    wget https://getcomposer.org/installer
    php installer
    mv composer.phar /usr/local/bin/composer
    composer require facebook/facebook-instant-articles-sdk-php
else
    echo '#############################################'
    echo '#          NOT INSTALLING DRUPAL            #'
    echo '#                                           #'
    echo '#  This can be enabled during build with:   #'
    echo '#  -e "INSTALL_DRUPAL=1"                    #'
    echo '#                                           #'
    echo '#############################################'
fi


