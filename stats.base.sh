#!/usr/bin/env bash

#DO NOT USE UNLESS YOU REALLY WANT TO DESTROY EVERY CONTAINER AND IMAGE ON THIS DROPLET
#docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)

docker image rm -f stats.grafana:latest

docker build -f stats.grafana.dockerfile --rm -t stats.grafana .

