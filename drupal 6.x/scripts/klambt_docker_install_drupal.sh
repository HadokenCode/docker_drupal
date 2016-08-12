#!/bin/bash

if [ "$INSTALL_DRUPAL" = 1 ]; then
    echo '#############################################'
    echo '#            INSTALLING DRUPAL              #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  -e "INSTALL_DRUPAL=0"                    #'
    echo '#                                           #'
    echo '#############################################'

    drush dl drupal-6 --destination=/var/www/html
    dir=`ls -l /var/www/html | awk '{print $9}' | grep 'drupal-'`
    mv $dir/* .
    chown -R www-data:www-data /var/www/html
else
    echo '#############################################'
    echo '#          NOT INSTALLING DRUPAL            #'
    echo '#                                           #'
    echo '#  This can be enabled during build with:   #'
    echo '#  -e "INSTALL_DRUPAL=1"                    #'
    echo '#                                           #'
    echo '#############################################'
fi


