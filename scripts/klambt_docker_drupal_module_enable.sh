#!/bin/bash
module="$1"
done=0

klambt_docker_drupal_module_download.sh $module
drush pm-enable -y $module