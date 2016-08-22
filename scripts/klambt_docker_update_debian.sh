#!/bin/bash
echo ' '

if [ "$UPDATE_DEBIAN" = 1 ]; then
    echo '#############################################'
    echo '#         UPDATING Debian Packages          #'
    echo '#                                           #'
    echo '#  This can be disabled during build with:  #'
    echo '#  ENV UPDATE_DEBIAN=0                      #'
    echo '#                                           #'
    echo '#############################################'

    apt-get update
    apt-get upgrade -y

else 
    echo '#############################################'
    echo '#       NOT updating Debian Packages        #'
    echo '#                                           #'
    echo '#  This can be enable during build with:    #'
    echo '#  ENV UPDATE_DEBIAN=1                      #'
    echo '#                                           #'
    echo '#############################################'
fi
echo ' '

if [ ! "$DEBIAN_INSTALL_PACKAGES" = 0 ]; then
    echo '##############################################'
    echo '#       INSTALLING Debian Packages           #'
    echo '#    based on $DEBIAN_INSTALL_PACKAGES       #'
    echo '#                                            #'
    echo '#  This can be disabled during runtime with: #'
    echo '#  -e "DEBIAN_INSTALL_PACKAGES=0"            #'
    echo '#                                            #'
    echo '#  This can be enable during build with:     #'
    echo '#  ENV DEBIAN_INSTALL_PACKAGES=1             #'
    echo '#                                            #'
    echo '##############################################'

    packages=$(echo $DEBIAN_INSTALL_PACKAGES | tr "," "\n")
    for package in $packages
    do
        package=${package%$'\r'}
        echo "Install Debian Package: $package"
        apt-get install -y $package
    done

    echo 'Setting DEBIAN_INSTALL_PACKAGES=0';
    export DEBIAN_INSTALL_PACKAGES=0
else
    echo '####################################################'
    echo '#   No Debian Packages to install found in         #'
    echo '#          $DEBIAN_INSTALL_PACKAGES                #'
    echo '#                                                  #'
    echo '#  This enabled during runtime with:               #'
    echo '#  -e "DEBIAN_INSTALL_PACKAGES=vi,telnet"          #'
    echo '#                                                  #'
    echo '#  This can be enable during build with:           #'
    echo '#  ENV DEBIAN_INSTALL_PACKAGES=vim,telnet          #'
    echo '#                                                  #'
    echo '####################################################'
fi