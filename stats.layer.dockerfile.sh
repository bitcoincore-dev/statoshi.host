#!/usr/bin/env bash

#DO NOT USE UNLESS YOU REALLY WANT TO DESTROY EVERY CONTAINER AND IMAGE ON THIS DROPLET
#docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)
docker image rm -f stats.localhost:latest

docker build -f stats.layer.dockerfile --rm -t stats.localhost .
#docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 stats.localhost
docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 stats.localhost

