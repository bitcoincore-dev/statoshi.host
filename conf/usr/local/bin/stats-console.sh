#!/bin/bash
#
REPO=$(find / -maxdepth 5 -type d -name stats.bitcoincore.dev 2>&1) | grep -v find
export REPO
DATADIR=$(find / -maxdepth 3 -type d -name .bitcoin 2>&1) | grep -v find
export DATADIR

if hash docker 2>/dev/null; then
    mkdir -p /usr/local/bin
    install -v $REPO/conf/local/bin/stats-console.sh /usr/local/bin/stats-console.sh
    docker exec -it $(echo $(docker ps | awk '{print $1}' | awk 'NR==2')) sh -c  "tail -f $DATADIR/debug.log"
else
        watch tail -f $DATADIR/debug.log
fi
