# [http://stats.bitcoincore.dev:3000](http://stats.bitcoincore.dev:3000)

## [statoshi.bitcoincore.dev.git](https://github.com/bitcoincore-dev/statoshi.bitcoincore.dev.git) GUI layer



This docker image pulls data from `http://stats.bitcoincore.dev:8080` by default to ensure basic realtime node statistics with minimal understanding of statsd/graphite/grafana configuration. 

### localhost installation

[install docker](https://docs.docker.com/get-docker/)

```
git clone https://github.com/bitcoincore-dev/stats.bitcoincore.dev.git $HOME/stats.bitcoincore.dev
```
```
cd $HOME/stats.bitcoincore.dev
```
```
./localhost.dockerfile.sh
```

[open: localhost:3000](http://localhost:3000)

#### Appoximate image foot print 160mb

```bash
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
stats.localhost     latest              ac393a120371        About a minute ago   158MB
```
