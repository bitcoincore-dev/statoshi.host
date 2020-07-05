#BEGIN statoshi.dockerfile
RUN df -H
###########################################
# We build Statoshi last
FROM config-final as clone-stats-bitcoincore-dev
###########################################

WORKDIR /
# Change to your fork
RUN git clone -b live https://github.com/bitcoincore-dev/stats.bitcoincore.dev --depth 2 stats.bitcoincore.dev && mkdir -p /stats.bitcoincore.dev/depends/SDKs

################################################
FROM clone-stats-bitcoincore-dev as make-depends
################################################

#RUN make -j $(nproc) download -C /stats.bitcoincore.dev/depends

############################
FROM make-depends as autogen
############################

RUN cd /stats.bitcoincore.dev && ./autogen.sh

#########################
FROM autogen as configure
#########################

RUN cd /stats.bitcoincore.dev  && ./configure --disable-wallet --disable-tests --disable-hardening --disable-man --enable-util-cli --enable-util-tx --with-gui=no --without-miniupnpc --disable-bench

######################
FROM configure as make
######################

RUN cd /stats.bitcoincore.dev && make -j $(nproc)

###########################
FROM make as strip-binaries
###########################

RUN strip /stats.bitcoincore.dev/src/bitcoind

RUN strip /stats.bitcoincore.dev/src/bitcoin-cli

RUN strip /stats.bitcoincore.dev/src/bitcoin-tx

###########################
FROM strip-binaries as copy
###########################

RUN cp    /stats.bitcoincore.dev/src/bitcoind /usr/bin

RUN cp    /stats.bitcoincore.dev/src/bitcoin-cli /usr/bin

RUN cp    /stats.bitcoincore.dev/src/bitcoin-tx /usr/bin

RUN cp    /stats.bitcoincore.dev/check_synced.sh /usr/bin

RUN df -H
#END statoshi.dockerfile

