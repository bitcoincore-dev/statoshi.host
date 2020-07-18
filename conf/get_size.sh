#!/bin/bash
    get_size(){

        blocksSize=$(ls -hal $HOME/.bitcoin/blocks | awk '/total/{print $2}')
        echo $blocksSize > $HOME/.bitcoin/blocks_size.txt

        chainStateSize=$(ls -hal $HOME/.bitcoin/chainstate | awk '/total/{print $2}')
        echo $chainStateSize > $HOME/.bitcoin/chainstate_size.txt

        dataBaseSize=$(ls -hal $HOME/.bitcoin/database | awk '/total/{print $2}')
        echo $dataBaseSize > $HOME/.bitcoin/database_size.txt
    }
get_size
