ARG BASE_IMAGE=alpine:3.11.6

FROM ${BASE_IMAGE} as statoshi-base-layer

LABEL dev.bitcoincore.statoshi="statoshi"
LABEL version="v0.20.99.0"
LABEL description="statoshi.base.layer"
LABEL github="https://github.com/bitcoincore-dev/statoshi.bitcoincore.dev"
LABEL maintainer="admin@bitcoincore.dev"

FROM statoshi-base-layer as install-most-packages

RUN apk update && apk upgrade && apk add --no-cache musl busybox bash-completion
RUN apk -U add coreutils
RUN apk add --update --no-cache nodejs nodejs-npm

RUN apk update && apk upgrade
RUN apk add --no-cache \
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
    vim

RUN git config --global advice.detachedHead false

RUN apk add --no-cache \
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
    py3-setuptools

EXPOSE 80 2003-2004 2013-2014 2023-2024 3000 8080 8333 18333 8125 8125/udp 8126

RUN df -H
FROM install-most-packages as clone-repo

# Change to your fork
RUN git clone https://github.com/bitcoincore-dev/statoshi.bitcoincore.dev --depth 1 /statoshi && mkdir -p /statoshi/depends/SDKs

FROM clone-repo as make-depends

#RUN cd /statoshi && make -j $(nproc) download -C /statoshi/depends

FROM make-depends as autogen

RUN cd /statoshi && ./autogen.sh

FROM autogen as configure

RUN cd /statoshi && ./configure --disable-wallet --disable-tests --disable-hardening --disable-man --enable-util-cli --enable-util-tx --with-gui=no --without-miniupnpc --disable-bench

FROM configure as make

RUN cd /statoshi && make -j $(nproc)

FROM make as strip-copy

RUN cp /statoshi/README.md /

RUN strip /statoshi/src/bitcoind

RUN strip /statoshi/src/bitcoin-cli

RUN strip /statoshi/src/bitcoin-tx

RUN cp /statoshi/src/bitcoind /usr/local/bin

RUN cp /statoshi/src/bitcoin-cli /usr/local/bin

RUN cp /statoshi/src/bitcoin-tx /usr/local/bin

#RUN cp /statoshi/sys.daemon.py /usr/bin

#RUN cp /statoshi/check_synced.sh /usr/bin

#COPY ./conf/run-grafana.sh /usr/local/bin

COPY ./conf/entrypoint /usr/local/bin

FROM strip-copy as cleanup

RUN df -H

#RUN rm -rf /statoshi #NOT YET!

RUN df -H

FROM cleanup as done

#TODO create a standalone entrypoint for bitcoind/statoshid only
#This one is for the full stack
#ENTRYPOINT ["/usr/local/bin/entrypoint"]

