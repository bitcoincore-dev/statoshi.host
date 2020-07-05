#END INSERT
#BEGIN FOOTER
#################
#################
#################
#################
#################

RUN rm -rf /stats.bitcoincore.dev

RUN rm -rf /var/cache/apk/*

RUN rm -rf /var/cache/man/*

RUN df -H
ENTRYPOINT ["/entrypoint"]
#END FOOTER
