#!/bin/bash
module="$1"
done=0

klambt_docker_drupal_module_download.sh $module
drush pm-enable -y $module

####### CKEDITOR ########
cd /var/www/html/sites/all/modules/
rm -rf ckeditor
wget https://ftp.drupal.org/files/projects/ckeditor-7.x-1.x-dev.zip
unzip ckeditor-7.x-1.x-dev.zip
rm ckeditor-7.x-1.x-dev.zip
cd /var/www/html/sites/all/modules/ckeditor
rm -rf ckeditor
wget http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.5.11/ckeditor_4.5.11_full.zip
unzip ckeditor_4.5.11_full.zip
rm ckeditor_4.5.11_full.zip
chown -R www-data:www-data /var/www/html/sites/all/modules/ckeditor

### js.php & htaccess ###
mv /var/www/html/sites/all/modules/js/js.php /var/www/html/js.php
chown -R www-data:www-data /var/www/html/js.php
echo '# Rewrite JavaScript callback URLs of the form js.php?q=x.' >> /var/www/html/.htaccess
echo 'RewriteCond %{REQUEST_URI} ^\/([a-z]{2}\/)?js\/.*' >> /var/www/html/.htaccess
echo 'RewriteRule ^(.*)$ js.php?q=$1 [L,QSA]' >> /var/www/html/.htaccess
echo 'RewriteCond %{QUERY_STRING} (^|&)q=((\/)?[a-z]{2})?(\/)?js\/.*' >> /var/www/html/.htaccess
echo 'RewriteRule .* js.php [L]' >> /var/www/html/.htaccess
