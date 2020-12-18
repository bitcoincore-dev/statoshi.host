#!/bin/bash
#
#REPO=$(find / -maxdepth 5 -type d -name stats.bitcoincore.dev 2>&1) | grep -v find
#export REPO
if [[ "$OSTYPE" == "linux-gnu" ]]; then
if hash crontab 2>/dev/null; then
    mkdir -p /etc/cron.hourly
    echo '*/7 * * * * $REPO/conf/usr/local/bin/stats-bitcoind.sh' >> /etc/cron.hourly/bitcoind
else
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        apt update
        apt install cron
        systemctl enable cron
        # crontab -e #no need
    mkdir -p /etc/cron.hourly
    echo '*/7 * * * * $REPO/conf/usr/local/bin/stats-bitcoind.sh' >> /etc/cron.hourly/bitcoind
    fi
fi
fi
if hash docker 2>/dev/null; then
    mkdir -p /usr/local/bin
    docker exec -it $(echo $(docker ps | awk '{print $1}' | awk 'NR==2')) sh -c  "/usr/local/bin/bitcoind -daemon"
else
    if hash bitcoind 2>/dev/null; then
        /usr/local/bin/./bitcoind
    else
        echo  /usr/local/bin/stats-bitcoind.sh ?
    fi
fi
