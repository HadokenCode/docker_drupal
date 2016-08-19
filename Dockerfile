FROM klambt/webserver:latest
MAINTAINER Tim Weyand <tim.weyand@klambt.de>

ENV UPDATE_DEBIAN              1
ENV INSTALL_DRUSH              1
ENV INSTALL_DRUPAL             1
ENV INSTALL_COMPOSER           1
ENV MYSQL_DATABASE             drupal
ENV MYSQL_USER                 drupal
ENV MYSQL_PASSWORD             drupal
ENV MYSQL_PORT                 3306
ENV MYSQL_LINK                 database_server
ENV DRUPAL_USERNAME            admin
ENV DRUPAL_USER_PASSWORD       admin
ENV DRUPAL_USER_MAIL           webmaster@domain.tld
ENV DRUPAL_SITE_MAIL           webmaster@domain.tld
ENV DRUPAL_MEMCACHE_SERVER     0
ENV DRUPAL_VARNISH_SERVER      0
ENV DRUPAL_VARNISH_KEY         xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx

COPY ./conf /root/conf
COPY ./scripts/* /usr/local/bin/

RUN chmod +x /usr/local/bin/klambt_docker_*.sh \
 && /usr/local/bin/klambt_docker_update_debian.sh \
 && /usr/local/bin/klambt_docker_install_drush.sh \
 && /usr/local/bin/klambt_docker_install_drupal.sh

# @todo customization
CMD ["/usr/local/bin/klambt_docker_drupal_start.sh"]