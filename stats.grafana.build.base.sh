#!/usr/bin/env bash
docker image rm -f stats.grafana:latest
docker build -f stats.grafana.dockerfile --rm -t stats.grafana .
