#!/bin/bash

#Install the docker container first
#   docker pull mariadb:10.3.8
#   containername=mariadbtest
#   mylocalport=50012
#   mypassword=supersecret
#   docker run --name ${containername} -p 127.0.0.1:${mylocalport}:3306 -e MYSQL_ROOT_PASSWORD=${mypassword} -d mariadb:10.3.8

containername=mariadbtest
mylocalport=50010
mypassword=supersecret

#check it
check=$(docker ps -a | grep "\b${containername}\b")
if [ -z "${check}" ] ; then
    echo "Ooops the container '${containername}' does not exist";
    docker run --name ${containername} \
        -p 127.0.0.1:${mylocalport}:3306 \
        -e MYSQL_ROOT_PASSWORD=${mypassword} \
        -d mariadb:10.3.8
fi

#fire up mariadb
docker restart ${containername}

#check again
docker ps -a | grep "\b${containername}\b"

