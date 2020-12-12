#!/bin/bash
#
if hash docker 2>/dev/null; then
    mkdir -p /usr/local/bin
    #install -v /root/stats.bitcoincore.dev/conf/local/bin/docker-gettxoutsetinfo.sh /usr/local/bin/
    docker exec -it $(echo $(docker ps | awk '{print $1}' | awk 'NR==2')) sh -c  "tail -f $HOME/.bitcoin/debug.log"
else
        watch tail -f $HOME/.bitcoin/debug.log
fi
