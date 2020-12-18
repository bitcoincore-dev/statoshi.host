#!/bin/sh
export LC_CTYPE=C

NORMAL="\033[1;0m"
STRONG="\033[1;1m"
GREEN="\033[1;32m"

DATADIR=$(find / -maxdepth 3 -type d -name .bitcoin 2>&1) | grep -v find
REPO=$(find / -maxdepth 5 -type d -name stats.bitcoincore.dev 2>&1) | grep -v find
config=$(find $REPO -maxdepth 2 -type f -name bitcoin.conf)

randgen() {
	output=$(cat /dev/urandom | tr -dc '0-9a-zA-Z!@$%^&*_+-' | head -c${1:-$1}) 2>/dev/null
	echo $output
}

GenPasswd(){
	sed -i "/rpcuser=/ c \rpcuser=USER-"$(randgen 32)"" $1
	sed -i "/rpcpassword=/ c \rpcpassword=PW-"$(randgen 64)"" $1
	print_green "Generated random user / password in:" " $1\n"
}

print_green() {
	local prompt="${STRONG}$1${GREEN}$2${NORMAL}"
	printf "${prompt}%s"
}

for file in $config; do
	if grep -F "changeme" $file 1>/dev/null; then
		GenPasswd $file
	fi
done

install -v $config $DATADIR/bitcoin.conf
echo end
exit 0
