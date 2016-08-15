#!/bin/bash
sleep 30
echo '#############################################'
echo '#          CLEAN INSTALL DRUPAL             #'
echo '#                                           #'
echo '#                                           #'
echo '#############################################'
drush site-install --db-url=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_LINK:$MYSQL_PORT/$MYSQL_DATABASE expert --locale=$DRUPAL_LOCALE --account-name=$DRUPAL_USERNAME --account-mail=$DRUPAL_USER_MAIL --account-pass=$DRUPAL_USER_PASSWORD --site-mail=$DRUPAL_SITE_MAIL --site-name=$DRUPAL_SITE_NAME


apache2-foreground