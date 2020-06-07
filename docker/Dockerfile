FROM debian:buster-slim

ENV PATH "/statoshi:/statoshi/depends:/statoshi/src:/statoshi/depends/x86_64-pc-linux-gnu:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"


RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    automake \
    binutils \
    bsdmainutils \
    ca-certificates \
    cmake \
    curl \
    diffoscope \
    doxygen \
    g++-multilib \
    git \
    libtool \
    lbzip2 \
    make \
    nsis \
    patch \
    pkg-config \
    python3 \
    ripgrep \
    vim \
    xz-utils
# Split cross compile dependencies out.
# apt cant seem to install everything at once
RUN apt-get install --no-install-recommends -y \
    libssl-dev \
    libevent-dev \
    libbz2-dev \
    libcap-dev \
    librsvg2-bin \
    libtiff-tools \
    libtinfo5 \
    libz-dev \
    python3-setuptools \
    g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    g++-arm-linux-gnueabihf \
    binutils-arm-linux-gnueabihf \
    binutils-riscv64-linux-gnu \
    g++-riscv64-linux-gnu \
    g++-mingw-w64-x86-64

RUN git clone https://github.com/bitcoincore-dev/statoshi && mkdir statoshi/depends/SDKs

RUN make download -C statoshi/depends

RUN cd /statoshi/depends && make

RUN cd /statoshi && ./autogen.sh

RUN cd /statoshi && ./configure   --disable-wallet  --disable-tests --disable-hardening  --disable-man  --enable-util-cli --enable-util-tx  --with-gui=no --without-miniupnpc --prefix=/statoshi/depends/x86_64-pc-linux-gnu



#./configure   --disable-wallet  --disable-tests --disable-hardening  --disable-man  --enable-util-cli --enable-util-tx  --with-gui=no 

RUN cd /statoshi && make

#RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

# https://github.com/bitcoin/bitcoin/blob/master/doc/build-windows.md#footnotes
#RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix

RUN cd /statoshi &&  $(pwd)/src/./bitcoind -prune=550
