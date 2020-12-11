#!/bin/bash
#
if [[ "$OSTYPE" == "linux-"* ]]; then
if hash docker 2>/dev/null; then
    mkdir -p /usr/local/bin
    docker exec -it $(echo $(docker ps | awk '{print $1}' | awk 'NR==2')) sh -c  "/usr/local/bin/bitcoin-cli pruneblockchain"
else
    if hash bitcoind 2>/dev/null; then
        /usr/local/bin/./bitcoin-cli pruneblockchain
    else
        echo  /usr/local/bin/stats-prune.sh ?
    fi
fi
fi
