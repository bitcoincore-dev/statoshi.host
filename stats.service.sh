#!/usr/bin/env bash
TIME=$(date +%s)

#DO NOT USE UNLESS YOU REALLY WANT TO DESTROY EVERY CONTAINER AND IMAGE ON THIS DROPLET
# make -fmk destroy-all
# docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)

concat(){
cat header.dockerfile > stats.bitcoincore.dev.dockerfile
cat statoshi.dockerfile >> stats.bitcoincore.dev.dockerfile
cat footer.dockerfile >> stats.bitcoincore.dev.dockerfile
}
build(){
docker build -f stats.bitcoincore.dev.dockerfile --rm -t stats.bitcoincore.dev .
}
extract(){
#disable entrypoint
sed '$d' stats.bitcoincore.dev.dockerfile | sed '$d' | sed '$d' >  stats.bitcoincore.dev.extract.dockerfile
docker build -f stats.bitcoincore.dev.extract.dockerfile --rm -t statoshi.extract$TIME .
#docker run --name temp-container-name-$TIME statoshi.extract /bin/true &
docker run --name statoshi.extract$TIME  statoshi.extract$TIME /bin/true
docker cp statoshi.extract$TIME:/usr/local/bin/bitcoind        $(pwd)/conf/usr/local/bin/bitcoind
docker cp statoshi.extract$TIME:/usr/local/bin/bitcoin-cli     $(pwd)/conf/usr/local/bin/bitcoin-cli
docker cp statoshi.extract$TIME:/usr/local/bin/bitcoin-tx      $(pwd)/conf/usr/local/bin/bitcoin-tx
docker rm statoshi.extract$TIME

rm -f  stats.bitcoincore.dev.extract.dockerfile
}
run(){
docker run --restart always --name stats.bitcoincore.dev -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 stats.bitcoincore.dev .
}
message(){
docker image ls
docker ps
}
concat
build
extract
message
run
