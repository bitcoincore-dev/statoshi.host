#!/usr/bin/env bash
#This layer ideally needs to only be built once
#We install most needed packages for the full stack
docker build -f statoshi.base.layer.dockerfile --rm -t statoshi.base.layer .
#We dont run it - only build on top of it
#docker run -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 statoshi .
docker image ls

