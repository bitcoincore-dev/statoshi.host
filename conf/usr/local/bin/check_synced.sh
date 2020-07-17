#!/bin/bash
TIME1=$(date +%s)
TIME2=$TIME1
DIFF_TIME=0
AVG_DIFF_TIME=0
CUM_DIFF_TIME=0
COUNT=0
    check_synced(){
        while [ ! $localCheck ]
        do
            while [ $localCheck -ne $crossCheck ]
            do
                localCheck=$(/home/root/stats.bitcoincore.dev/conf/usr/local/bin/./bitcoin-cli getblockcount)
                crossCheck=$(wget -q -O - http://blockchain.info/q/getblockcount)
                while [ $crossCheck -gt 0 ]
                do
                COUNT=$((COUNT+1))
                # echo count $COUNT
                localSize=$(ls -hal ~/.bitcoin/blocks | awk '/total/{print $2}')
                localCheck=$(/home/root/stats.bitcoincore.dev/conf/usr/local/bin/./bitcoin-cli getblockcount)
                #echo $localCheck
                diff=$((crossCheck-localCheck))
                DIFF_TIME=$((TIME2-TIME1))
                # echo diff_time $DIFF_TIME
                CUM_DIFF_TIME=$((CUM_DIFF_TIME+DIFF_TIME))
                # echo cum_diff_time $CUM_DIFF_TIME
                AVG_DIFF_TIME=$(((CUM_DIFF_TIME)/COUNT))
                # echo avg_diff_time $AVG_DIFF_TIME
                TIME1=$TIME2
                TIME2=$(date +%s)
                echo $diff       $TIME2 >> $HOME/diff.log
                echo $localCheck $TIME2 >> $HOME/localCheck.log
                echo $crossCheck $TIME2 >> $HOME/crossCheck.log
                echo $diff
                #echo $localCheck
                #echo $crossCheck
                #echo $localSize
                crossCheck=$(wget -q -O - http://blockchain.info/q/getblockcount)
                clear
                done
            done
        done
    }
check_synced
