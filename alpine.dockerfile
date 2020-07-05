ARG BASE_IMAGE=alpine:3.11.5

FROM ${BASE_IMAGE} as set-grafana-env

RUN apk update && apk upgrade && apk add musl busybox bash-completion
#REF:https://github.com/orangesys/alpine-grafana/blob/master/Dockerfile

ENV GRAFANA_VERSION=7.0.0
RUN mkdir -p /tmp/grafana \
  && wget -P /tmp/ https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
  && tar xfz /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components=1 -C /tmp/grafana

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

WORKDIR $GF_PATHS_HOME

RUN set -ex \
    && addgroup -S grafana \
    && adduser -S -G grafana grafana \
    && apk add --no-cache libc6-compat ca-certificates su-exec bash

FROM set-grafana-env as grafana-config

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
COPY ./conf/run-grafana.sh /run-grafana.sh

#exposing all ports for grafana bitcoin statsd graphite now...
EXPOSE 80 2003-2004 2013-2014 2023-2024 3000 8080 8333 18333 8125 8125/udp 8126

#RUN echo "TODO: More config for grafana here..."
#RUN /run-grafana.sh &
#CMD ["/run.sh"] <<- moved to /conf/entrypoint

FROM grafana-config as set-env

WORKDIR /

ENV PATH "/statoshi:/statoshi/depends:/statoshi/src:/statoshi/depends/x86_64-pc-linux-gnu:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

FROM set-env as apk-add-statoshi-depends

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
# apt can't seem to install everything at once
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
    #libssl-dev \
    openssl-dev \
    libevent-dev \
    libzmq \
    zeromq-dev \
    protobuf-dev \
    linux-headers \
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

RUN git config --global advice.detachedHead false

#build statsd and graphite...
FROM apk-add-statoshi-depends as base

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

# We build Statoshi last
FROM production as git-clone-statoshi-repo

# Change to your fork
RUN git clone https://github.com/bitcoincore-dev/statoshi --depth 1 /statoshi && mkdir -p /statoshi/depends/SDKs

FROM git-clone-statoshi-repo as build-statoshi

RUN cd /statoshi && ./contrib/install_db4.sh .

RUN make download -C /statoshi/depends

RUN cd /statoshi && ./autogen.sh

RUN cd /statoshi && ./configure --disable-wallet  --disable-tests --with-gui=no
#RUN cd /statoshi && ./configure --disable-wallet  --disable-tests

RUN cd /statoshi && make

ENTRYPOINT ["/entrypoint"]

#TODO Simplify and minimize all this shit if possible...