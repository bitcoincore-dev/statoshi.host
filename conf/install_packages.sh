#!/bin/sh
export LC_CTYPE=C
apk update && apk upgrade && apk add $VERBOSE musl busybox bash-completion git
apk -U add $VERBOSE coreutils
apk add --update $VERBOSE nodejs nodejs-npm

apk update && apk upgrade
apk add $VERBOSE \
autoconf \
automake \
binutils \
ca-certificates \
cmake \
curl \
doxygen \
git \
libtool \
make \
patch \
pkgconfig \
python3 \
py3-psutil \
vim \
g++ \
build-base \
boost-libs \
libgcc \
libstdc++ \
musl \
boost-system \
boost-build \
boost-dev \
openssl-dev \
libevent-dev \
libzmq \
zeromq-dev \
protobuf-dev \
linux-headers \
libbz2 \
libcap-dev \
librsvg \
tiff-tools \
zlib-dev \
py3-setuptools \
cairo \
collectd \
collectd-disk \
collectd-nginx \
findutils \
librrd \
logrotate \
memcached \
nginx \
nodejs \
npm \
nodejs-npm \
py3-pyldap \
redis \
runit \
sqlite \
expect \
dcron \
py3-mysqlclient \
mysql-dev \
mysql-client \
postgresql-dev \
postgresql-client \
iptables \
alpine-sdk \
git \
libffi-dev \
pkgconfig \
py3-cairo \
py3-pip \
py3-virtualenv==16.7.8-r0 \
openldap-dev \
python3-dev \
rrdtool-dev \
wget

rm -rf \
     /etc/nginx/conf.d/default.conf \
&& mkdir -p \
     /var/log/carbon \
     /var/log/graphite
df -H

REPO=stats.bitcoincore.dev
export REPO
apk add libzmq
pip3 install pyzmq

echo "$REPO/conf/config.bitcoin.conf.sh"
$REPO/conf/./config.bitcoin.conf.sh

mkdir -p /etc/bitcoin
mkdir -p /var/lib/bitcoin
mkdir -p /root/.bitcoin
mkdir -p /home/root/.bitcoin

install $VERBOSE $REPO/conf/bitcoin.conf /etc/bitcoin/bitcoin.conf
install $VERBOSE $REPO/conf/bitcoin.conf /root/.bitcoin/bitcoin.conf
install $VERBOSE $REPO/conf/bitcoin.conf /home/root/.bitcoin/bitcoin.conf
install $VERBOSE $REPO/conf/additional.conf /etc/bitcoin/additional.conf
install $VERBOSE $REPO/conf/additional.conf /root/.bitcoin/additional.conf
install $VERBOSE $REPO/conf/additional.conf /home/root/.bitcoin/additional.conf

install $VERBOSE $REPO/conf/usr/local/bin/bitcoind /usr/local/bin/bitcoind
install $VERBOSE $REPO/conf/usr/local/bin/bitcoind /usr/bin/bitcoind

install $VERBOSE $REPO/conf/usr/local/bin/bitcoin-cli /usr/local/bin/bitcoin-cli
install $VERBOSE $REPO/conf/usr/local/bin/bitcoin-cli /usr/bin/bitcoin-cli

install $VERBOSE $REPO/conf/usr/local/bin/bitcoin-tx /usr/local/bin/bitcoin-tx
install $VERBOSE $REPO/conf/usr/local/bin/bitcoin-tx /usr/bin/bitcoin-tx

install $VERBOSE $REPO/conf/usr/local/bin/check_synced.sh /usr/local/bin/checked_synced.sh

###########################
# Micro containers may not be able to compile from source - signed binaries verified here
###########################

apk add --no-cache gnupg
gpg --refresh-keys
gpg --import  $REPO/conf/usr/local/bin/randymcmillan.asc

while read fingerprint keyholder_name; do gpg --keyserver hkps://keys.openpgp.org --recv-keys ${fingerprint}; done < $REPO/conf/usr/local/bin/keys.txt

gpg --verify $REPO/conf/usr/local/bin/bitcoind.gpg $REPO/conf/usr/local/bin/bitcoind

gpg --verify $REPO/conf/usr/local/bin/bitcoin-cli.gpg $REPO/conf/usr/local/bin/bitcoin-cli

gpg --verify $REPO/conf/usr/local/bin/bitcoin-tx.gpg $REPO/conf/usr/local/bin/bitcoin-tx

df -H

install $REPO/conf/entrypoint /
install $REPO/conf/usr/local/bin/systemMetrics.Daemon.py /
install $REPO/conf/usr/local/bin/requirements.txt /
python3 -m pip install -r requirements.txt

rm -rf $REPO
rm -rf /var/cache/man/*
rm -rf /opt/graphite/examples/*

npm --force cache clean # && cd /usr/lib/node_modules && npm uninstall -y npm

rm -rf /opt/graphite/examples/*

df -H

