#!/bin/bash
#Ubuntu usage
#
# chmod +x make-run-all.sh
#
# apt update
# apt install cron
# systemctl enable cron
# crontab -e

# Example command
# 30 17 * * 2 curl http://www.google.com
# Here are some more examples of how to use cron’s scheduling component:
#
# * * * * * - Run the command every minute.
# 12 * * * * - Run the command 12 minutes after every hour.
# 0,15,30,45 * * * * - Run the command every 15 minutes.
# */15 * * * * - Run the command every 15 minutes.
# 0 4 * * * - Run the command every day at 4:00 AM.
# 0 4 * * 2-4 - Run the command every Tuesday, Wednesday, and Thursday at 4:00 AM.
# 20,40 */8 * 7-12 * - Run the command on the 20th and 40th minute of every 8th hour every day of the last 6 months of the year.
mkdir -p /usr/local/bin
#install -v /root/stats.bitcoincore.dev/conf/usr/local/bin/docker-gettxoutsetinfo.sh /usr/local/bin/docker-gettxoutsetinfo.sh
# 0,7,14,21,28,35,42,49,56 * * * * /usr/local/bin/docker-gettxoutsetinfo.sh

docker exec -it $(echo $(docker ps | awk '{print $1}' | awk 'NR==2')) sh -c  "/usr/local/bin/bitcoin-cli getmininginfo"
