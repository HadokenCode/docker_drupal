# klambt/drupal
[![](https://images.microbadger.com/badges/version/klambt/drupal.svg)](http://microbadger.com/images/klambt/drupal "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/klambt/drupal.svg)](https://microbadger.com/images/klambt/drupal "Get your own image badge on microbadger.com")

*This Docker is still in development*

This Dockerimage is intented to be used as a Drupal Base Image for our Sites. You may use it, at your own risk. The Image is based on klambt/webserver ([Dockerhub](https://hub.docker.com/r/klambt/webserver/) or [Github](https://github.com/klambt/docker_webserver)) which is an enhanced image of [php:7.0-apache](https://hub.docker.com/_/php/).

This Docker is intended to be highly customizable, to:
* fit our needs
* being able to making it public

It is possible to run it as a "Clean Install" or with an Preloaded Database (Update). Modules and Debian Packages can be added at Runtime or Build.

PULL
=======
```docker pull klambt/drupal:latest```

Building
========

```docker build -t klambt/drupal:latest .```

## Autobuild
This Image will be updated if:
* The [php](https://hub.docker.com/_/php/) Base Image is Updated (hook)
* The [drupal](https://hub.docker.com/_/drupal/) Image is Updated (hook)
* We change it in github

##TAGS

| tag                          | description                      | size |
| ---------------------------- | -------------------------------- | ---- |
| latest | currently drupal 7 for development purposes   | [![](https://images.microbadger.com/badges/image/klambt/drupal.svg)](https://microbadger.com/images/klambt/drupal "Get your own image badge on microbadger.com") |
| drupal-8 | Latest [Drupal 8.x](https://www.drupal.org/8) Version    | [![](https://images.microbadger.com/badges/image/klambt/drupal:drupal-8.svg)](https://microbadger.com/images/klambt/drupal:drupal-8 "Get your own image badge on microbadger.com") |
| thunder  | Latest [Thunder](http://www.thunder.org) Version   | [![](https://images.microbadger.com/badges/image/klambt/drupal:thunder.svg)](https://microbadger.com/images/klambt/drupal:thunder "Get your own image badge on microbadger.com") |
| drupal-7 | Latest Drupal 7.x Version | [![](https://images.microbadger.com/badges/image/klambt/drupal:drupal-7.svg)](https://microbadger.com/images/klambt/drupal:drupal-7 "Get your own image badge on microbadger.com") |
| drupal-6 |  Drupal 6 Version - Just to test if we can be flexible with this docker ([php:5.6-apache](https://hub.docker.com/_/php/)) | [![](https://images.microbadger.com/badges/image/klambt/drupal:drupal-6.svg)](https://microbadger.com/images/klambt/drupal:drupal-6 "Get your own image badge on microbadger.com") |


##Drupal 7 Modules enabled
* [varnish] (https://www.drupal.org/project/varnish)
* [expire] (https://www.drupal.org/project/expire)
* [memcache] (https://www.drupal.org/project/memcache)
* [search_api] (https://www.drupal.org/project/search_api)
* [search_api_solr] (https://www.drupal.org/project/search_api_solr)
* [xmlsitemap] (https://www.drupal.org/project/xmlsitemap)
* [rules] (https://www.drupal.org/project/rules)
* [redirect] (https://www.drupal.org/project/redirect)
* [fast_404] (https://www.drupal.org/project/fast_404)
* [composer_manager] (https://www.drupal.org/project/composer_manager)
* [fb_instant_articles] (https://www.drupal.org/project/fb_instant_articles)
* [amp] (https://www.drupal.org/project/amp)
* [amptheme] (https://www.drupal.org/project/amptheme)

Settings & Customization
======

In the next Section, we will describe howto use some of our customizing options. In the Example Section, we will describe some usecases (still in progress)

## Core Hacks
We will not support Core Hacks

## Modules & Themes

There are several Methods to integrate & install Modules at Buildtime and Runtime to this Docker:
* Public Themes and Modules can be added during Build:
- by modify the file [Dockerroot]/conf/drupal-7-modules.conf to your needs. It is a Textfile with one modulename in each line. The Modules will be downloaded and installed via drush.
- by setting the Environment DRUPAL_INSTALL_MODULES to a list of your chosing (seperated by ",");

* Private Themes and Modules can be added during Build:
- by adding them to the custom_modules and custom_themes Folder
- by pulling them directly from your git repository (see Environment Options)


## Environment Options

### Build

| option                          | description                      |  Default Values |
| ---------------------------- | -------------------------------- | -------------------------------- | 
| UPDATE_DEBIAN | Update Debian Packages | 1 = true |
| DEBIAN_INSTALL_PACKAGES| Install Debian Packages, seperated by "," | 0 = false |
| INSTALL_DRUSH | Install [Drush](http://www.drush.org/) | 1 = true |
| INSTALL_DRUPAL | Install [Drupal](http://www.drupal.org/) | 1 = true |
| DRUPAL_INSTALL_MODULES| Install Drupal Modules, seperated by "," | 0 = false |
| GIT_PULL_CUSTOM| Pull Private Modules & Themes from GitHub | 0 = false |
| GIT_CUSTOM_SOURCES_SERVER| Git Server | github.com |
| GIT_CUSTOM_SOURCES_REPOS| Git Directory (for example klambt/docker_drupal) | 0 = false |
| GIT_USERNAME | Git Username | 0 = false |
| GIT_PASSWORD | Git Password | 0 = false |
| GIT_CUSTOM_MODULES_PATH | Modules Path inside the git repository | 0 = false |
| GIT_CUSTOM_THEMES_PATH | Themes Path inside the git repository | 0 = false |


### Runtime

| option                          | description                      |  Default Values |
| ---------------------------- | -------------------------------- | -------------------------------- | 
| DEBIAN_INSTALL_PACKAGES| Install Debian Packages, seperated by "," | 0 = false |
| DRUPAL_USERNAME | Admin Username (User 0) | admin |
| DRUPAL_USER_PASSWORD | Admin Password | generated |
| DRUPAL_USER_MAIL | Admin User E-Mail Adress | webmaster@domain.tld |
| DRUPAL_SITE_MAIL | E-Mail Adress of the Site | webmaster@domain.tld |
| DRUPAL_MEMCACHE_SERVER | Linkname or Hostname to Memcache Server | 0 = disabled |
| DRUPAL_VARNISH_SERVER | Linkname or Hostip to Varnish Server | 0 = disabled |
| DRUPAL_VARNISH_KEY | Varnish Key to Ban Content on Varnish Server | --- |
| DRUPAL_INSTALL_MODULES| Install Drupal Modules, seperated by "," | 0 = false |
| MYSQL_DATABASE | Drupal Database | drupal |
| MYSQL_USER | Username | drupal | 
| MYSQL_PASSWORD | User Password | drupal |
| MYSQL_LINK | Linkname or Hostname to Database Server | database_server |
| GIT_PULL_CUSTOM| Pull Private Modules & Themes from GitHub | 0 = false |
| GIT_CUSTOM_SOURCES_SERVER| Git Server | github.com |
| GIT_CUSTOM_SOURCES_REPOS| Git Directory (for example klambt/docker_drupal) | 0 = false |
| GIT_USERNAME | Git Username | 0 = false |
| GIT_PASSWORD | Git Password | 0 = false |
| GIT_CUSTOM_MODULES_PATH | Modules Path inside the git repository | 0 = false |
| GIT_CUSTOM_THEMES_PATH | Themes Path inside the git repository | 0 = false |

Directorys
======

### [klambt/docker_drupal] (https://github.com/klambt/docker_drupal)

| path                          | description                      |
| ---------------------------- | -------------------------------- | 
| conf/ | Configuration Files |
| custom_modules/ | Custom Modules to be integrated at Build |
| custom_themes/ | Custom Themes to be integrated at Build |
| scripts/klambt_docker_*.sh | Logic to get everything up and running  |
| Dockerfile | tag:latest  |

### Dockerimage

| path                          | description                      |
| ---------------------------- | -------------------------------- | 
| /var/www/html/ | Drupal Base |
| /var/www/html/sites/all/modules/custom | Custom Modules |
| /var/www/html/sites/all/themes/custom  | Custom Themes |
| /usr/local/bin/klambt_docker_*.sh | Configuration Scripts |

Examples
======

The following example for Development, will start an clean installed drupal, with working memcache, varnish, solr integration. It is intended to get a working Drupal Installation up in couple of Minutes.

Since it is a Development Deployment, we will expose the Ports:
* 8983 for SOLR Administration
* 3306 for MySQL
* 81 for PHPMyAdmin
* 80 for Drupal

We will need three files in the same directory.

*docker-compose.yml*
```
version: '2'
services:
  drupal_memcached:
    image: memcached:alpine
    container_name: drupal_memcached
  drupal_database:
    image: mysql:5.7
    container_name: drupal_database
    ports:
      - "3306:3306"
    env_file:
      - ./database.env
  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    container_name: drupal_phpmyadmin
    ports:
      - "81:80"    
    links:
      - drupal_database:db     
  webserver:
    image: klambt/drupal:drupal-7
    container_name: drupal_webserver
    links:
      - drupal_memcached
      - drupal_database
      - drupal_solr
    env_file:
      - ./database.env
      - ./drupal.env
    depends_on:
      - drupal_database      
  drupal_varnish:
    image: klambt/varnish:latest
    container_name: drupal_varnish   
    links: 
      - webserver:backend-app
    ports:
      - "80:80"
  drupal_solr:
    image: klambt/solr
    container_name: drupal_solr
    ports:
      - "8983:8983"  
```

drupal.env
```
DRUPAL_USERNAME=admin
DRUPAL_USER_MAIL=webmaster@domain.com
DRUPAL_SITE_MAIL=webmaster@domain.com
DRUPAL_MEMCACHE_SERVER=drupal_memcached
DRUPAL_VARNISH_SERVER=drupal_varnish
DRUPAL_VARNISH_KEY=d518244a-5bc5-482d-8f8d-a0420e7cb7b7
DRUPAL_LOCALE=de_DE
```

*database.env*
```
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=drupal
MYSQL_USER=drupal
MYSQL_PASSWORD=drupal
MYSQL_PORT=3306
MYSQL_LINK=drupal_database
```

Starting up our Service with a single command:
```
docker-compose up
```



*more documentation to follow*

