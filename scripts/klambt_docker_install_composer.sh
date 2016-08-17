#!/bin/bash
mkdir -p /var/www/.composer
mkdir -p /var/www/html/sites/default/files/composer
mkdir -p /var/www/html/sites/default/files/vendor

whoami
cd /var/www/html/sites/default/files/composer/
composer install
composer require facebook/facebook-instant-articles-sdk-php


chown -R www-data:www-data /var/www/html/sites/default/files
