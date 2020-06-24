#!/usr/bin/env bash
TIME=$(date +%s)

cat header.dockerfile > stats.bitcoincore.dev.dockerfile
cat statoshi.dockerfile >> stats.bitcoincore.dev.dockerfile
cat footer.dockerfile >> stats.bitcoincore.dev.dockerfile

#docker image rm -f grafana.statsd.prebuild:latest
#docker image rm -f stats.bitcoincore.dev:latest

docker build -f stats.bitcoincore.dev.dockerfile --rm -t stats.bitcoincore.dev . && docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 stats.bitcoincore.dev .

#docker builder prune -af
