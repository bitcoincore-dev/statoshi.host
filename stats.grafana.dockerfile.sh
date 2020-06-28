#!/usr/bin/env bash

docker image rm -f stats.grafana

docker build -f stats.grafana.dockerfile --rm -t stats.grafana .
docker run -p 3000:3000 stats.grafana
