#!/usr/bin/env bash

#DO NOT USE UNLESS YOU REALLY WANT TO DESTROY EVERY CONTAINER AND IMAGE ON THIS DROPLET
#docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)

if [[ -d $HOME/stats.grafana ]];then
    cd $HOME/stats.grafana && git pull -f  origin +master:master
else
    git clone --depth 1 https://github.com/bitcoincore-dev/stats.grafana.git  $HOME/stats.grafana

cd $HOME/stats.grafana

fi
docker image rm -f stats.bitcoincore.dev:latest

docker build -f stats.dockerfile --rm -t stats.bitcoincore.dev .
docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 stats.bitcoincore.dev

