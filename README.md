# klambt/drupal

*This Docker is still in development*

This Dockerimage is intented to be used as a Drupal Base Image for our Sites. You may use it, at your own risk.

The Image is based on klambt/webserver ([Dockerhub](https://hub.docker.com/r/klambt/webserver/) or [Github](https://github.com/klambt/docker_webserver)) which is an enhanced image of [php:7.0-apache](https://hub.docker.com/_/php/).

Autobuild
======
This Image will be updated if:
* The [php](https://hub.docker.com/_/php/) Base Image is Updated (hook)
* The [drupal](https://hub.docker.com/_/drupal/) Image is Updated (hook)
* We change it in github

TAGS
======
* latest - currently drupal 7 for development purposes
* drupal-8 - Latest [Drupal 8.x](https://www.drupal.org/8) Version
* thunder  - Latest [Thunder](http://www.thunder.org) Version 
* drupal-7 - Latest Drupal 7.x Version
* drupal-6 - Drupal 6 Version - Just to test if we can be flexible with this docker ([php:5.6-apache](https://hub.docker.com/_/php/))

PULL
=======
```docker pull klambt/drupal:latest```

Building
========

```docker build -t klambt/drupal:latest .```

*more documentation to follow*

