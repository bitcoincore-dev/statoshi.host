#!/usr/bin/env bash

#DO NOT USE UNLESS YOU REALLY WANT TO DESTROY EVERY CONTAINER AND IMAGE ON THIS DROPLET
#docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)


docker image rm -f stats.localhost

docker build -f stats.localhost.dockerfile --rm -t stats.localhost .
#NOTE this assumes that the host isn't already using port 80
docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 stats.localhost
#ELSE use
#docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 3000:3000 stats.localhost

