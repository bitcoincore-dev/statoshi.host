FROM alpine:3.11.5 as build-bitcoin

ENV PATH "/statoshi:/statoshi/depends:/statoshi/src:/statoshi/depends/x86_64-pc-linux-gnu:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"


RUN apk update && apk upgrade && apk add \
    autoconf \
    automake \
    binutils \
    #bsdmainutils \
    ca-certificates \
    cmake \
    curl \
    #diffoscope \
    doxygen \
    #g++-multilib \
    git \
    libtool \
    #lbzip2 \
    make \
    #nsis \
    patch \
    #pkg-config \
    pkgconfig \
    python3 \
    #ripgrep \
    vim
    #\
    #xz-utils
# Split cross compile dependencies out.
# apt cant seem to install everything at once
RUN apk add \
    g++ \
    build-base \
    boost-libs \
    libgcc \
    libstdc++ \
    musl \
    boost-system \
    boost-build \
    boost-dev \
    #libssl-dev \
    openssl-dev \
    libevent-dev \
    libzmq \
    #libbz2-dev \
    libbz2 \
    libcap-dev \
    #librsvg2-bin \
    librsvg \
    #libtiff-tools \
    tiff-tools \
    #libtinfo5 \
    #libz-dev \
    zlib-dev \
    #python3-setuptools \
    py3-setuptools
    #\
    #g++-aarch64-linux-gnu \
    #binutils-aarch64-linux-gnu \
    #g++-arm-linux-gnueabihf \
    #binutils-arm-linux-gnueabihf \
    #binutils-riscv64-linux-gnu \
    #g++-riscv64-linux-gnu \
    #g++-mingw-w64-x86-64

RUN git clone https://github.com/bitcoincore-dev/statoshi && mkdir statoshi/depends/SDKs

#RUN make download -C statoshi/depends

#RUN cd /statoshi/depends && make

RUN cd /statoshi && ./autogen.sh

RUN cd /statoshi && ./configure   --disable-wallet  --disable-tests --disable-hardening  --disable-man  --enable-util-cli --enable-util-tx  --with-gui=no --without-miniupnpc # --prefix=/statoshi/depends/x86_64-pc-linux-gnu



#./configure   --disable-wallet  --disable-tests --disable-hardening  --disable-man  --enable-util-cli --enable-util-tx  --with-gui=no 

RUN cd /statoshi && make

#RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

# https://github.com/bitcoin/bitcoin/blob/master/doc/build-windows.md#footnotes
#RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix

#RUN cd /statoshi &&  $(pwd)/src/./bitcoind -prune=550






#build stats and graphite...
FROM build-bitcoin as base
LABEL maintainer="Denys Zhdanov <denis.zhdanov@gmail.com>"

RUN true \
 && apk add --no-cache \
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
 && rm -rf \
      /etc/nginx/conf.d/default.conf \
 && mkdir -p \
      /var/log/carbon \
      /var/log/graphite

FROM base as build
LABEL maintainer="Denys Zhdanov <denis.zhdanov@gmail.com>"

RUN true \
 && apk add --update \
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
      wget \
 && virtualenv /opt/graphite \
 && . /opt/graphite/bin/activate \
 && pip3 install \
      django==2.2.12 \
      django-statsd-mozilla \
      fadvise \
      gunicorn==20.0.4 \
      msgpack-python \
      redis \
      rrdtool \
      python-ldap \
      mysqlclient \
      psycopg2 \
      django-cockroachdb==2.2.*

ARG version=1.1.7

# install whisper
ARG whisper_version=${version}
ARG whisper_repo=https://github.com/graphite-project/whisper.git
RUN git clone -b ${whisper_version} --depth 1 ${whisper_repo} /usr/local/src/whisper \
 && cd /usr/local/src/whisper \
 && . /opt/graphite/bin/activate \
 && python3 ./setup.py install

# install carbon
ARG carbon_version=${version}
ARG carbon_repo=https://github.com/graphite-project/carbon.git
RUN . /opt/graphite/bin/activate \
 && git clone -b ${carbon_version} --depth 1 ${carbon_repo} /usr/local/src/carbon \
 && cd /usr/local/src/carbon \
 && pip3 install -r requirements.txt \
 && python3 ./setup.py install

# install graphite
ARG graphite_version=${version}
ARG graphite_repo=https://github.com/graphite-project/graphite-web.git
RUN . /opt/graphite/bin/activate \
 && git clone -b ${graphite_version} --depth 1 ${graphite_repo} /usr/local/src/graphite-web \
 && cd /usr/local/src/graphite-web \
 && pip3 install -r requirements.txt \
 && python3 ./setup.py install

# install statsd (as we have to use this ugly way)
ARG statsd_version=0.8.6
ARG statsd_repo=https://github.com/statsd/statsd.git
WORKDIR /opt
RUN git clone "${statsd_repo}" \
 && cd /opt/statsd \
 && git checkout tags/v"${statsd_version}" \
 && npm install

COPY conf/opt/graphite/conf/                             /opt/defaultconf/graphite/
COPY conf/opt/graphite/webapp/graphite/local_settings.py /opt/defaultconf/graphite/local_settings.py

# config graphite
COPY conf/opt/graphite/conf/*.conf /opt/graphite/conf/
COPY conf/opt/graphite/webapp/graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
WORKDIR /opt/graphite/webapp
RUN mkdir -p /var/log/graphite/ \
  && PYTHONPATH=/opt/graphite/webapp /opt/graphite/bin/django-admin.py collectstatic --noinput --settings=graphite.settings

# config statsd
COPY conf/opt/statsd/config/ /opt/defaultconf/statsd/config/

FROM base as production
LABEL maintainer="Denys Zhdanov <denis.zhdanov@gmail.com>"

ENV STATSD_INTERFACE udp

COPY conf /

# copy /opt from build image
COPY --from=build /opt /opt

# defaults
EXPOSE 80 2003-2004 2013-2014 2023-2024 8080 8125 8125/udp 8126
VOLUME ["/opt/graphite/conf", "/opt/graphite/storage", "/opt/graphite/webapp/graphite/functions/custom", "/etc/nginx", "/opt/statsd/config", "/etc/logrotate.d", "/var/log", "/var/lib/redis"]

STOPSIGNAL SIGHUP

ENTRYPOINT ["/entrypoint"]
