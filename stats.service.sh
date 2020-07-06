#!/usr/bin/env bash
TIME=$(date +%s)

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
docker image ls
#docker run --name temp-container-name-$TIME statoshi.extract /bin/true &
docker run --name statoshi.extract$TIME  statoshi.extract$TIME /bin/true
docker cp statoshi.extract$TIME:/usr/local/bin/bitcoind        $(pwd)/conf/usr/local/bin/bitcoind
docker cp statoshi.extract$TIME:/usr/local/bin/bitcoin-cli     $(pwd)/conf/usr/local/bin/bitcoin-cli
docker cp statoshi.extract$TIME:/usr/local/bin/bitcoin-tx      $(pwd)/conf/usr/local/bin/bitcoin-tx
docker rm statoshi.extract$TIME

rm -f  stats.bitcoincore.dev.extract.dockerfile
}
run(){
docker run -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 stats.bitcoincore.dev .
}
concat
build
extract
run
