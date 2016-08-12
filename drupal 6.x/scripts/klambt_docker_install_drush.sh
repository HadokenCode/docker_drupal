#!/bin/bash
echo '/scripts/install_drush.sh:'

if [ "$INSTALL_DRUSH" = 1 ]; then
    echo '#############################################'
    echo '#            INSTALLING DRUSH               #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  -e "INSTALL_DRUSH=0"                     #'
    echo '#                                           #'
    echo '#############################################'

    apt-get install -y mysql-client
    php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > /root/drush
    php /root/drush core-status
    chmod +x /root/drush
    mv /root/drush /usr/local/bin
    drush init -y
else
    echo '#############################################'
    echo '#          NOT INSTALLING DRUSH             #'
    echo '#                                           #'
    echo '#  This can be enabled during build with:   #'
    echo '#  -e "INSTALL_DRUSH=1"                     #'
    echo '#                                           #'
    echo '#############################################'
fi
