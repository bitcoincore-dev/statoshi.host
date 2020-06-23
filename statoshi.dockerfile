ARG BASE_IMAGE=alpine:3.11.5

FROM ${BASE_IMAGE} as set-initial-env

LABEL dev.bitcoincore.statoshi="statoshi"
LABEL version="v0.20.99.0"
LABEL description="Statoshi Docker"
LABEL github="https://github.com/bitcoincore-dev/statoshi"
LABEL maintainer="admin@bitcoincore.dev"

RUN apk update && apk upgrade && apk add musl busybox bash-completion
RUN apk -U add coreutils
RUN apk add --update nodejs nodejs-npm

RUN df -H

#REF:https://github.com/orangesys/alpine-grafana/blob/master/Dockerfile

ENV GRAFANA_VERSION=7.0.0
RUN mkdir -p /tmp/grafana \
  && wget -P /tmp/ https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
  && tar xfz /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components=1 -C /tmp/grafana

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/statoshi:/statoshi/depends:/statoshi/src:/statoshi/depends/x86_64-pc-linux-gnu:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG_CUSTOM="/etc/grafana/custom.ini" \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

#NOTE: simply exposing the ports in the dockerfile isnt enough
#REF:  https://www.ctl.io/developers/blog/post/docker-networking-rules
#REF: docker build -f Dockerfile --rm -t statoshi . && docker run -it -p 80:80 -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 statoshi .
EXPOSE 80 2003-2004 2013-2014 2023-2024 3000 8080 8333 18333 8125 8125/udp 8126

WORKDIR $GF_PATHS_HOME

RUN set -ex \
    && addgroup -S grafana \
    && adduser -S -G grafana grafana \
    && apk add --no-cache libc6-compat ca-certificates su-exec bash

FROM set-initial-env as grafana-config

COPY --from=0 /tmp/grafana "$GF_PATHS_HOME"
RUN mkdir -p "$GF_PATHS_HOME/.aws" \
    && mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
        "$GF_PATHS_PROVISIONING/dashboards" \
        "$GF_PATHS_PROVISIONING/notifiers" \
        "$GF_PATHS_LOGS" \
        "$GF_PATHS_PLUGINS" \
        "$GF_PATHS_DATA" \
    && chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" \
    && chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"

COPY ./config.docker/grafana.ini "$GF_PATHS_CONFIG"
COPY ./config.docker/custom.ini "$GF_PATHS_CONFIG_CUSTOM"
COPY ./conf/run-grafana.sh /run-grafana.sh

RUN df -H

FROM grafana-config as set-env

WORKDIR /

FROM set-env as apk-add-statoshi-depends

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

RUN df -H

RUN git config --global advice.detachedHead false

#build statsd and graphite...
FROM apk-add-statoshi-depends as base

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
 && rm -rf \
      /etc/nginx/conf.d/default.conf \
 && mkdir -p \
      /var/log/carbon \
      /var/log/graphite

RUN df -H

FROM base as build

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
#COPY conf/opt/graphite/webapp/graphite/local_settings.py /opt/defaultconf/graphite/settings.py

# config graphite
COPY conf/opt/graphite/conf/*.conf /opt/graphite/conf/
COPY conf/opt/graphite/webapp/graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
#COPY conf/opt/graphite/webapp/graphite/local_settings.py /opt/graphite/webapp/graphite/settings.py
WORKDIR /opt/graphite/webapp
RUN mkdir -p /var/log/graphite/ \
  && PYTHONPATH=/opt/graphite/webapp /opt/graphite/bin/django-admin.py collectstatic --noinput --settings=graphite.settings

# config statsd
COPY conf/opt/statsd/config/ /opt/defaultconf/statsd/config/

RUN df -H

FROM base as production

ENV STATSD_INTERFACE udp
#ENV STATSD_INTERFACE tcp/udp

COPY conf /

# copy /opt from build image
COPY --from=build /opt /opt

VOLUME ["/opt/graphite/conf", "/opt/graphite/storage", "/opt/graphite/webapp/graphite/functions/custom", "/etc/nginx", "/opt/statsd/config", "/etc/logrotate.d", "/var/log", "/var/lib/redis"]

STOPSIGNAL SIGHUP

RUN df -H

# We build Statoshi last
FROM production as clone-repo

ARG STATS_BITCOINCORE_DEV=stats.bitcoincore.dev

# Change to your fork
RUN git clone https://github.com/bitcoincore-dev/${STATS_BITCOINCORE_DEV} --depth 1 /${STATS_BITCOINCORE_DEV} && mkdir -p /${STATS_BITCOINCORE_DEV}/depends/SDKs

FROM clone-repo as make-depends

RUN cd /${STATS_BITCOINCORE_DEV} && make -j $(nproc) download -C /${STATS_BITCOINCORE_DEV}/depends

FROM make-depends as autogen

RUN cd /${STATS_BITCOINCORE_DEV} && ./autogen.sh

FROM autogen as configure

RUN cd /${STATS_BITCOINCORE_DEV}  && ./configure --disable-wallet --disable-tests --disable-hardening --disable-man --enable-util-cli --enable-util-tx --with-gui=no --without-miniupnpc --disable-bench

FROM configure as make

RUN cd /${STATS_BITCOINCORE_DEV} && make -j $(nproc)

FROM make as strip-copy

RUN strip /${STATS_BITCOINCORE_DEV}/src/bitcoind

RUN strip /${STATS_BITCOINCORE_DEV}/src/bitcoin-cli

RUN strip /${STATS_BITCOINCORE_DEV}/src/bitcoin-tx

RUN cp    /${STATS_BITCOINCORE_DEV}/src/bitcoind /usr/bin

RUN cp    /${STATS_BITCOINCORE_DEV}/src/bitcoin-cli /usr/bin

RUN cp    /${STATS_BITCOINCORE_DEV}/src/bitcoin-tx /usr/bin

RUN cp    /${STATS_BITCOINCORE_DEV}/check_synced.sh /usr/bin

RUN cp    /${STATS_BITCOINCORE_DEV}/dashboards /usr/share/grafana

RUN cp    /${STATS_BITCOINCORE_DEV}/conf/run-grafana.sh /usr/bin

FROM strip-copy as cleanup

RUN df -H

RUN rm -rf /${STATS_BITCOINCORE_DEV}

RUN df -H

FROM cleanup as done

ENTRYPOINT ["/entrypoint"]

#TODO Simplify and minimize all this shit if possible...
