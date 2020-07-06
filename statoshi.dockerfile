#BEGIN statoshi.dockerfile
RUN df -H
###########################################
# We build Statoshi last
FROM config-final as clone-stats-bitcoincore-dev
###########################################

WORKDIR /
# Change to your fork
RUN git clone -b master https://github.com/bitcoincore-dev/stats.bitcoincore.dev --depth 2 stats.bitcoincore.dev && mkdir -p /stats.bitcoincore.dev/depends/SDKs

################################################
FROM clone-stats-bitcoincore-dev as make-depends
################################################

#RUN make -j $(nproc) download -C /stats.bitcoincore.dev/depends

############################
FROM make-depends as autogen
############################

#RUN cd /stats.bitcoincore.dev && ./autogen.sh

#########################
FROM autogen as configure
#########################

#RUN cd /stats.bitcoincore.dev  && ./configure --disable-wallet --disable-tests --disable-hardening --disable-man --enable-util-cli --enable-util-tx --with-gui=no --without-miniupnpc --disable-bench

######################
FROM configure as make
######################

#RUN cd /stats.bitcoincore.dev && make -j $(nproc)

###########################
FROM make as strip-binaries
###########################

#RUN strip /stats.bitcoincore.dev/src/bitcoind
#
#RUN strip /stats.bitcoincore.dev/src/bitcoin-cli
#
#RUN strip /stats.bitcoincore.dev/src/bitcoin-tx

###########################
FROM strip-binaries as copy
###########################

#RUN cp    /stats.bitcoincore.dev/src/bitcoind /usr/local/bin/bitcoind
#
#RUN cp    /stats.bitcoincore.dev/src/bitcoin-cli /usr/local/bin/bitcoin-cli
#
#RUN cp    /stats.bitcoincore.dev/src/bitcoin-tx /usr/local/bin/bitcoin-tx
#
RUN cp    /stats.bitcoincore.dev/conf/usr/local/bin/check_synced.sh /usr/local/bin/checked_synced.sh

###########################
# Micro containers may not be able to compile from source - signed binaries verified here
###########################
RUN apk add --no-cache gnupg
RUN gpg --refresh-keys
RUN gpg --import  /stats.bitcoincore.dev/conf/usr/local/bin/randymcmillan.asc

RUN while read fingerprint keyholder_name; do gpg --keyserver hkps://keys.openpgp.org --recv-keys ${fingerprint}; done <  /stats.bitcoincore.dev/conf/usr/local/bin/keys.txt

RUN gpg --verify /stats.bitcoincore.dev/conf/usr/local/bin/bitcoind.gpg /stats.bitcoincore.dev/conf/usr/local/bin/bitcoind
RUN cp    /stats.bitcoincore.dev/conf/usr/local/bin/bitcoind /usr/local/bin/bitcoind

RUN gpg --verify /stats.bitcoincore.dev/conf/usr/local/bin/bitcoin-cli.gpg /stats.bitcoincore.dev/conf/usr/local/bin/bitcoin-cli
RUN cp    /stats.bitcoincore.dev/conf/usr/local/bin/bitcoin-cli /usr/local/bin/bitcoin-cli

RUN gpg --verify /stats.bitcoincore.dev/conf/usr/local/bin/bitcoin-tx.gpg /stats.bitcoincore.dev/conf/usr/local/bin/bitcoin-tx
RUN cp    /stats.bitcoincore.dev/conf/usr/local/bin/bitcoin-tx /usr/local/bin/bitcoin-tx

RUN df -H
#END statoshi.dockerfile

