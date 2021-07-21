#!/usr/bin/env bash

checkbrew() {

    if hash brew 2>/dev/null; then
        brew update
        brew upgrade
        brew install autoconf automake berkeley-db4 libtool boost miniupnpc pkg-config python qt libevent qrencode
        brew install librsvg codespell shellcheck
    else
        #example - execute script with perl
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        checkbrew
    fi
}

if [[ "$OSTYPE" == "linux-gnu" ]]; then

    apt install autoconf
    apt install libdb4.8++-dev
    apt -y install libboost libevent miniupnpc libdb4.8 qt libqrencode univalue libzmq3
    apt install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
    apt install libevent-dev libboost-system-dev libboost-filesystem-dev libboost-test-dev libboost-thread-dev
    apt install libminiupnpc-dev
    apt install libzmq3-dev
    apt install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools
    apt install libqrencode-dev

elif [[ "$OSTYPE" == "darwin"* ]]; then
    checkbrew
elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo TODO add support for $OSTYPE
elif [[ "$OSTYPE" == "msys" ]]; then
    echo TODO add support for $OSTYPE
elif [[ "$OSTYPE" == "win32" ]]; then
    echo TODO add support for $OSTYPE
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo TODO add support for $OSTYPE
else
    echo TODO add support for $OSTYPE
fi

