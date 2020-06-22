## Statoshi: Bitcoin Core + statistics logging

## What is Statoshi?

Statoshi's objective is to protect Bitcoin by bringing transparency to the activity 
occurring on the node network. By making this data available, Bitcoin developers can 
learn more about node performance, gain operational insight about the network, and 
the community can be informed about attacks and aberrant behavior in a timely fashion.

There is a live Grafana dashboard at [statoshi.info](http://statoshi.info)

## License

Statoshi is released under the terms of the MIT license. See [COPYING](COPYING) for more
information or see http://opensource.org/licenses/MIT.

## Development Process

Statoshi's changeset to Bitcoin Core is applied in the `master` branch and is
built and tested after each merge from upstream or from a pull request. However,
it not guaranteed to be completely stable. We do not recommend using Statoshi
as a Bitcoin wallet.

A guide for Statoshi developers is available [here](https://medium.com/@lopp/statoshi-developer-s-guide-241ac9ab9993#.s1rfi3fv6)

## Other Notes

A system metrics daemon is available [here](https://github.com/jlopp/bitcoin-utils/blob/master/systemMetricsDaemon.py)

Statoshi also supports running multiple nodes that emit metrics to a single graphite instance. 
In order to facilitate this, you can add a line to bitcoin.conf that will partition each 
metric by the name of the host: statshostname=yourNodeName

## Docker Notes & [digitalocean.com](https://m.do.co/c/ae5c7d05da91)

#### test grafana config

```
docker build -f grafana.dockerfile --rm -t grafana .
```

#### test grafana and statsd config

```
docker build -f grafana-statsd.dockerfile --rm -t grafana-statsd .
```

```
docker run -it -p 3000:3000 grafana-statsd .

```

#### build all

```
docker build -f statoshi.dockerfile --rm -t statoshi .

```

#### run all

```
docker run -it -p 3000:3000 statoshi .

```

#### <span style="color:green">build and run</span>

```
docker build -f Dockerfile --rm -t statoshi . && docker run -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 statoshi .

```

```
ID=$(id -u) && docker run -d --user $ID --volume "$PWD/config.docker:/var/lib/grafana" -p 3000:3000 grafana/grafana:5.1.0
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
