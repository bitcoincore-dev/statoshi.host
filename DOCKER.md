## Docker Notes & [DigitalOcean.com](https://m.do.co/c/ae5c7d05da91)

#### <span style="color:green">run grafana.statsd docker service</span>
```
./grafana.statsd.service.sh
```

OR

```
docker build -f grafana.statsd.dockerfile --rm -t grafana.statsd . && docker run -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 grafana.statsd .
```

#### <span style="color:green">build and run all</span>

```
./statoshi.docker.service.sh
```

OR

```
docker build -f statoshi.dockerfile --rm -t statoshi . && docker run -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 statoshi .
```

#### view port settings

```
docker ps
```


#### example output
```
CONTAINER ID  IMAGE     COMMAND          CREATED        STATUS        PORTS                  NAMES
373c7497314c  statoshi  "/entrypoint ."  7 minutes ago  Up 7 minutes  0.0.0.0:32858->80/tcp  infallible_archimedes
```

#### inspect a container

```
docker port 373c7497314c

```
#### example output
```
2003/tcp -> 0.0.0.0:32857
2014/tcp -> 0.0.0.0:32854
8333/tcp -> 0.0.0.0:32847
18333/tcp -> 0.0.0.0:32846
8125/tcp -> 0.0.0.0:32849
8126/tcp -> 0.0.0.0:32848
2004/tcp -> 0.0.0.0:32856
2013/tcp -> 0.0.0.0:32855
2023/tcp -> 0.0.0.0:32853
2024/tcp -> 0.0.0.0:32852
3000/tcp -> 0.0.0.0:32851
8125/udp -> 0.0.0.0:32774
80/tcp -> 0.0.0.0:32858
8080/tcp -> 0.0.0.0:32850
```

--

<center>
##### <span style="color:red"> >>> DESTROY ALL CONTAINERS AND IMAGES (VERY DESTRUCTIVE) <<< </span>

Useful to clean out an isolated droplet - <span style="color:red">NEVER</span> use this on a mission critical system or droplet!
</center>

```
docker ps -aq && \
docker stop $(docker ps -aq) && \
docker rm $(docker ps -aq) && \
docker rmi $(docker images -q)
```
