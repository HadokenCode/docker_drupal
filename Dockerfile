FROM klambt/webserver:latest
MAINTAINER Tim Weyand <tim.weyand@klambt.de>

ENV UPDATE_DEBIAN              1
ENV INSTALL_DRUSH              1
ENV INSTALL_DRUPAL             1
ENV INSTALL_COMPOSER           1

COPY ./conf /root/conf
COPY ./scripts/* /usr/local/bin/

RUN chmod +x /usr/local/bin/klambt_docker_*.sh \
 && /usr/local/bin/klambt_docker_update_debian.sh \
 && /usr/local/bin/klambt_docker_install_drush.sh \
 && /usr/local/bin/klambt_docker_install_drupal.sh
 
USER www-data
 
RUN /usr/local/bin/klambt_docker_install_composer.sh
USER root
# @todo customization
CMD ["/usr/local/bin/klambt_docker_drupal_start.sh"]