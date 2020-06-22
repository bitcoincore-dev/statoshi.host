#!/usr/bin/env bash
    timed_wait=600
    vars_to_load(){
        ## Set vars to function such that they are set upon every call
        localCheck=$(bitcoin-cli getblockcount)
        crossCheck=$(wget -q -O - http://blockchain.info/q/getblockcount)
        diffBlocks=$(($crossCheck-$localCheck))
        localSize=$(ls -hal ~/.bitcoin/blocks | awk '/total/{print $2}')
    }
    check_sync(){
        while true
        do
            current_time=$(date)
            echo $current_time
            bitcoin-cli getblocktemplate
            if [ $? = 0 ]
            then
                echo "All synced up"
            else
                echo "Uh oh, running available checks"
                ## call function that runs it all on a timer
                networked_sync
                echo "Node has $localCheck of $crossCheck blocks available."
                echo "Size of local blockchain is $localSize"
            fi
            echo "Sleeping for $timed_wait seconds or $(($timed_wait/60)) minutes."
            sleep $timed_wait
        done
    }
    networked_sync(){
        vars_to_load
        ## Function to print difference in node sync
        if [ $diffBlocks -eq 0 ]
        then
            echo "Sync is good with $diffBlocks blocks off"
        else
            echo "Sync has $diffBlocks blocks left to download"
        fi
    }
    return_diff(){

        echo $diffBlocks

    }
    #check_sync
    return_diff
