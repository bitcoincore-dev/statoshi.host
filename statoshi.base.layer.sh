#!/usr/bin/env bash
#This layer ideally needs to only be built once
#We install most needed packages for the full stack
docker build -f statoshi.base.layer.dockerfile --rm -t statoshi.base.layer .
#We dont run it - only build on top of it
#docker run -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 statoshi .
docker run --name temp-container-name statoshi.base.layer /bin/true
docker cp temp-container-name:/usr/local/bin/bitcoind    ./conf/usr/local/bin/statoshid
docker cp temp-container-name:/usr/local/bin/bitcoin-cli ./conf/usr/local/bin/statoshi-cli
docker cp temp-container-name:/usr/local/bin/bitcoin-tx  ./conf/usr/local/bin/statoshi-tx
docker rm temp-container-name


docker build -f graphite.statsd.layer.dockerfile --rm -t graphite.statsd.layer .

docker prune -af
docker image ls

