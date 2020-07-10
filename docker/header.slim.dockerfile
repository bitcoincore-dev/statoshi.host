#BEGIN HEADER
ARG BASE_IMAGE=alpine:3.11.6
#####################################
FROM ${BASE_IMAGE} as set-initial-env
#####################################

LABEL dev.bitcoincore.stats="dev.bitcoincore.stats"
LABEL version="v0.20.99.0"
LABEL description="Statoshi Docker"
LABEL github="https://github.com/bitcoincore-dev/stats.bitcoincore.dev"
LABEL maintainer="admin@bitcoincore.dev"

RUN apk update && apk upgrade && apk add -v musl busybox bash-completion git
RUN apk -U add -v coreutils
RUN apk add --update -v nodejs nodejs-npm

#NOTE: simply exposing the ports in the dockerfile isnt enough
#REF:  https://www.ctl.io/developers/blog/post/docker-networking-rules
# We delay exposing ports until the last stage of the builds for reusablity
#EXPOSE 80 2003-2004 2013-2014 2023-2024 3000 8080 8333 18333 8125 8125/udp 8126
RUN git config --global advice.detachedHead false

RUN df -H
#########################################
FROM set-initial-env as grafana-download
#########################################

ENV GRAFANA_VERSION=7.0.0
RUN mkdir -p /tmp/grafana \
  && wget -P /tmp/ https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
  && tar xfz /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components=1 -C /tmp/grafana

RUN df -H
########################################
FROM grafana-download as grafana-config
########################################
#REF:https://github.com/orangesys/alpine-grafana/blob/master/Dockerfile

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG_DEFAULTS="/usr/share/grafana/conf/defaults.ini" \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

RUN df -H
######################################
FROM grafana-config as set-grafana-env
######################################

WORKDIR $GF_PATHS_HOME

RUN set -ex \
    && addgroup -S grafana \
    && adduser -S -G grafana grafana \
    #&& apk add --no-cache libc6-compat ca-certificates su-exec bash
    && apk add -v libc6-compat su-exec

#NOTE Once /tmp/grafana is copied to GF_PATHS_HOME we are free to modify the default configuration
COPY --from=grafana-config /tmp/grafana "$GF_PATHS_HOME"
RUN mkdir -p "$GF_PATHS_HOME/.aws" \
    && mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
        "$GF_PATHS_PROVISIONING/dashboards" \
        "$GF_PATHS_PROVISIONING/notifiers" \
        "$GF_PATHS_LOGS" \
        "$GF_PATHS_PLUGINS" \
        "$GF_PATHS_DATA" \
    && chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" \
    && chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"

#NOTE:/usr/share/grafana/conf/defaults.ini is read first
COPY ./conf/defaults.ini "$GF_PATHS_CONFIG_DEFAULTS"
COPY ./conf/grafana.ini "$GF_PATHS_CONFIG"
COPY ./conf/run-grafana.sh /usr/local/bin/
COPY ./conf/dashboards/* $GF_PATHS_PROVISIONING/dashboards/
COPY ./conf/datasources/* $GF_PATHS_PROVISIONING/datasources/

COPY ./conf/dashboards/* $GF_PATHS_HOME/dashboards/

RUN rm -f $GF_PATHS_HOME/public/img/grafana_icon.svg
RUN rm -f $GF_PATHS_HOME/public/img/grafana_mask_icon.svg

COPY ./src/qt/res/src/bitcoin.svg  $GF_PATHS_HOME/public/img/grafana_icon.svg
COPY ./src/qt/res/src/bitcoin.svg  $GF_PATHS_HOME/public/img/grafana_mask_icon.svg
COPY ./src/qt/res/src/bitcoin.svg  $GF_PATHS_HOME/public/img/bitcoin.svg

RUN df -H
#########################################
FROM set-grafana-env as apk-add-packages1
#########################################

WORKDIR /

RUN apk update && apk upgrade
RUN apk add -v \
    git \
    make \
    vim

RUN apk add -v \
    musl \
    openssl-dev \
    py3-setuptools

RUN df -H
###########################################
FROM apk-add-packages1 as apk-add-packages2
###########################################

RUN apk add -v \
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
 && rm -rf \
      /etc/nginx/conf.d/default.conf \
 && mkdir -p \
      /var/log/carbon \
      /var/log/graphite

RUN df -H
###########################################
FROM apk-add-packages2 as apk-add-packages3
###########################################

RUN apk add -v \
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

RUN df -H
#################################
FROM apk-add-packages3 as config1
#################################

RUN virtualenv /opt/graphite \
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
      twisted \
      django-cockroachdb==2.2.*

RUN df -H
#######################
FROM config1 as config2
#######################

# install whisper
ARG version=1.1.7
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

RUN df -H
#######################
FROM config2 as config3
#######################

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
#######################
FROM config3 as config4
#######################

ENV STATSD_INTERFACE udp
#ENV STATSD_INTERFACE tcp/udp

COPY conf /

# copy /opt from build image
COPY --from=config3 /opt /opt

VOLUME ["/opt/graphite/conf", "/opt/graphite/storage", "/opt/graphite/webapp/graphite/functions/custom", "/etc/nginx", "/opt/statsd/config", "/etc/logrotate.d", "/var/log", "/var/lib/redis"]

RUN df -H
#######################
FROM config4 as config-final
#######################
STOPSIGNAL SIGHUP

#################
#################
#################
#################
#################
#END HEADER
#BEGIN INSERT

