#!/bin/bash
module="$1"

if [ ! -d "/var/www/html/sites/all/modules/$module" ]; then
    if [ ! -d "/var/www/html/sites/all/modules/custom/$module" ]; then
       echo "Module $1 missing ... Downloading Module $1"
       drush pm-download -y $1
    else 
      echo "Custom Module $1 already exists"
    fi
else
    echo "Module $1 already exists"
fi
