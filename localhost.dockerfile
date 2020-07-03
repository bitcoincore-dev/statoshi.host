#Stand alone docker image that pulls data from statoshi.bitcoincore.dev:8080 by default
#Datasource config also has a http://localhost:8080 config as well - not default
ARG BASE_IMAGE=alpine:3.11.6
FROM ${BASE_IMAGE}
#TODO We will pull from our own compiled package later
ENV GRAFANA_VERSION=7.0.5
RUN mkdir /tmp/grafana \
  && wget -P /tmp/ https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
  && tar xfz /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components=1 -C /tmp/grafana

ARG BASE_IMAGE=alpine:3.11.6
FROM ${BASE_IMAGE}
LABEL stats.bitcoincore.dev="stats.bitcoincore.dev"

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG_DEFAULTS="/usr/share/grafana/conf/defaults.ini" \
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

COPY ./conf/grafana.ini "$GF_PATHS_CONFIG"
COPY ./conf/run.grafana.sh /run.grafana.sh
RUN chmod +x  /run.grafana.sh
COPY ./conf/dashboards/* $GF_PATHS_PROVISIONING/dashboards/
COPY ./conf/datasources/* $GF_PATHS_PROVISIONING/datasources/
COPY ./conf/dashboards/* $GF_PATHS_HOME/dashboards/

RUN rm -f $GF_PATHS_HOME/public/img/grafana_icon.svg
RUN rm -f $GF_PATHS_HOME/public/img/grafana_mask_icon.svg

COPY ./conf/img/bitcoin.svg  $GF_PATHS_HOME/public/img/grafana_icon.svg
COPY ./conf/img/bitcoin.svg  $GF_PATHS_HOME/public/img/grafana_mask_icon.svg
COPY ./conf/img/bitcoin.svg  $GF_PATHS_HOME/public/img/bitcoin.svg

EXPOSE 80 2003-2004 2013-2014 2023-2024 3000 8080 8333 18333 8125 8125/udp 8126

CMD ["/run.grafana.sh"]

