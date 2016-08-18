# klambt/drupal
[![](https://images.microbadger.com/badges/version/klambt/drupal.svg)](http://microbadger.com/images/klambt/drupal "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/klambt/drupal.svg)](https://microbadger.com/images/klambt/drupal "Get your own image badge on microbadger.com")

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
| tag                          | description                      | size |
| ---------------------------- | -------------------------------- | ---- |
| latest | currently drupal 7 for development purposes   | [![](https://images.microbadger.com/badges/version/klambt/drupal.svg)](http://microbadger.com/images/klambt/drupal "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/klambt/drupal.svg)](https://microbadger.com/images/klambt/drupal "Get your own image badge on microbadger.com") |
| drupal-8 | Latest [Drupal 8.x](https://www.drupal.org/8) Version    | [![](https://images.microbadger.com/badges/version/klambt/drupal:drupal-8.svg)](http://microbadger.com/images/klambt/drupal:drupal-8 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/klambt/drupal:drupal-8.svg)](https://microbadger.com/images/klambt/drupal:drupal-8 "Get your own image badge on microbadger.com") |
| thunder  | Latest [Thunder](http://www.thunder.org) Version   | [![](https://images.microbadger.com/badges/version/klambt/drupal:thunder.svg)](http://microbadger.com/images/klambt/drupal:thunder "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/klambt/drupal:thunder.svg)](https://microbadger.com/images/klambt/drupal:thunder "Get your own image badge on microbadger.com") |
| drupal-7 | Latest Drupal 7.x Version | [![](https://images.microbadger.com/badges/version/klambt/drupal.svg)](http://microbadger.com/images/klambt/drupal:drupal-7 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/klambt/drupal:drupal-7.svg)](https://microbadger.com/images/klambt/drupal:drupal-7 "Get your own image badge on microbadger.com") |
| drupal-6 |  Drupal 6 Version - Just to test if we can be flexible with this docker ([php:5.6-apache](https://hub.docker.com/_/php/)) | [![](https://images.microbadger.com/badges/version/klambt/drupal:drupal-6.svg)](http://microbadger.com/images/klambt/drupal:drupal-6 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/klambt/drupal:drupal-6.svg)](https://microbadger.com/images/klambt/drupal:drupal-6 "Get your own image badge on microbadger.com") |


PULL
=======
```docker pull klambt/drupal:latest```

Building
========

```docker build -t klambt/drupal:latest .```

*more documentation to follow*

