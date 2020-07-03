#!/usr/bin/env bash

#DO NOT USE UNLESS YOU REALLY WANT TO DESTROY EVERY CONTAINER AND IMAGE ON THIS DROPLET
#docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)

if [[ -d $HOME/stats.bitcoincore.dev ]];then
    cd $HOME/stats.bitcoincore.dev && git pull -f  origin +master:master
else
    git clone --depth 1 https://github.com/bitcoincore-dev/stats.bitcoincore.dev.git  $HOME/stats.bitcoincore.dev
fi
cd $HOME/stats.bitcoincore.dev

docker image rm -f stats.localhost

docker build -f stats.localhost.dockerfile --rm -t stats.localhost .
#NOTE this assumes that the host isn't already using port 80
docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 stats.localhost
#ELSE use
#docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 3000:3000 stats.localhost

