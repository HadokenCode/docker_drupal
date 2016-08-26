#!/bin/bash
    mkdir -p /var/www/html/sites/all/modules/custom
    mkdir -p /var/www/html/sites/all/themes/custom

    echo '#############################################'
    echo '#       Downloading DRUPAL Modules          #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  ENV INSTALL_DRUPAL=0                     #'
    echo '#                                           #'
    echo '#############################################'

    modules=$(grep -vE "^\s*#" /root/conf/drupal-7-modules.conf  | tr "\n" " ")
    for module in $modules
    do
        module=${module%$'\r'}
        klambt_docker_drupal_module_download.sh $module
    done


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
        klambt_docker_drupal_module_download.sh $module
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