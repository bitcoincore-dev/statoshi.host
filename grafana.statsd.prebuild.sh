#!/usr/bin/env bash

#If you are developing the grafana config we don't build statoshi everytime

TIME=$(date +%s)

docker image rm -f grafana.statsd.prebuild:latest

cat header.dockerfile > grafana.statsd.dockerfile
cat footer.dockerfile >> grafana.statsd.dockerfile

#docker build -f grafana.statsd.dockerfile -t grafana.statsd.prebuild.$TIME . && docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 grafana.statsd.prebuild.$TIME .

docker build -f grafana.statsd.dockerfile -t grafana.statsd.prebuild . && docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 grafana.statsd.prebuild .
