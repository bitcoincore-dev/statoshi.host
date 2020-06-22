#!/usr/bin/env bash
docker build -f grafana.statsd.dockerfile --rm -t grafana.statsd . && docker run -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 grafana.statsd .

