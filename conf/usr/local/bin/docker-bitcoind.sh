#!/bin/bash
#

if hash crontab 2>/dev/null; then
    echo '*/7 * * * * /root/stats.bitcoincore.dev/conf/usr/local/bin/docker-bitcoind.sh' >> /etc/cron.hourly/bitcoind
else
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        apt update
        apt install cron
        systemctl enable cron
        # crontab -e #no need
    echo '*/7 * * * * /root/stats.bitcoincore.dev/conf/usr/local/bin/docker-bitcoind.sh' >> /etc/cron.hourly/bitcoind
    fi
fi
if hash docker 2>/dev/null; then
    mkdir -p /usr/local/bin
    docker exec -it $(echo $(docker ps | awk '{print $1}' | awk 'NR==2')) sh -c  "/usr/local/bin/bitcoind"
else
    if hash bitcoind 2>/dev/null; then
        /usr/local/bin/./bitcoind
    else
        echo  /usr/local/bin/docker-bitcoind.sh ?
    fi
fi
