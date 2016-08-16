#!/bin/bash
#docker images | tail -n +2 | awk '{print $3}' > images.txt; docker rmi $(grep -vE "^\s*#" images.txt  | tr "\n" " ") -f; rm images.txt
#docker ps -a | awk {'print $1'} | tail -n +2  > containers.txt; docker rm $(grep -vE "^\s*#" containers.txt  | tr "\n" " ") -f; rm containers.txt
docker build -t klambt/drupal:latest .
docker-compose up --force-recreate
