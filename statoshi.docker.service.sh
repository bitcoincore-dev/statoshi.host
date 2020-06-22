#!/usr/bin/env bash
docker build -f statoshi.dockerfile --rm -t statoshi . && docker run -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 statoshi .

