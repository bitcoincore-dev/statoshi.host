Statoshi: Bitcoin Core + statistics logging

What is Statoshi?
----------------

Statoshi's objective is to protect Bitcoin by bringing transparency to the activity
occurring on the node network. By making this data available, Bitcoin developers can
learn more about node performance, gain operational insight about the network, and
the community can be informed about attacks and aberrant behavior in a timely fashion.

There is a live Grafana dashboard at [statoshi.info](https://statoshi.info)

License
-------

Statoshi is released under the terms of the MIT license. See [COPYING](COPYING) for more
information or see http://opensource.org/licenses/MIT.

Development Process
-------

Statoshi's changeset to Bitcoin Core is applied in the `master` branch and is
built and tested after each merge from upstream or from a pull request. However,
it not guaranteed to be completely stable. We do not recommend using Statoshi
as a Bitcoin wallet.

A guide for Statoshi developers is available [here](https://blog.lopp.net/statoshi-developer-s-guide/)

Other Notes
-------

A system metrics daemon is available [here](https://github.com/jlopp/bitcoin-utils/blob/master/systemMetricsDaemon.py)

Statoshi also supports running multiple nodes that emit metrics to a single graphite instance.
In order to facilitate this, you can add a line to bitcoin.conf that will partition each
metric by the name of the host: statshostname=yourNodeName

----
## [statoshi.dev](https://github.com/randymcmillan/statoshi.dev) [c5da6a856](https://github.com/randymcmillan/statoshi.dev/commit/c5da6a856)
##### &#36; <code>make</code>

	[ARGUMENTS]	
      args:
        - HOME=/Users/git
        - PWD=/Users/git/statoshi.dev
        - UMBREL=false
        - THIS_FILE=GNUmakefile
        - TIME=1627240731
        - ARCH=x86_64
        - HOST_USER=root
        - HOST_UID=0
        - PUBLIC_PORT=80
        - NODE_PORT=8333
        - SERVICE_TARGET=shell
        - ALPINE_VERSION=3.11.6
        - WHISPER_VERSION=1.1.7
        - CARBON_VERSION=1.1.7
        - GRAPHITE_VERSION=1.1.7
        - STATSD_VERSION=0.8.6
        - GRAFANA_VERSION=7.0.0
        - DJANGO_VERSION=2.2.24
        - PROJECT_NAME=statoshi.dev
        - DOCKER_BUILD_TYPE=all
        - SLIM=false
        - DOCKER_COMPOSE=/usr/local/bin/docker-compose
        - DOCKERFILE=statoshi.dev
        - DOCKERFILE_BODY=docker/statoshi.all
        - GIT_USER_NAME=randymcmillan
        - GIT_USER_EMAIL=randy.lee.mcmillan@gmail.com
        - GIT_SERVER=https://github.com
        - GIT_PROFILE=randymcmillan
        - GIT_BRANCH=master
        - GIT_HASH=c5da6a856
        - GIT_PREVIOUS_HASH=685148962
        - GIT_REPO_ORIGIN=git@github.com:RandyMcMillan/statoshi.dev.git
        - GIT_REPO_NAME=statoshi.dev
        - GIT_REPO_PATH=/Users/git/statoshi.dev
        - DOCKERFILE=statoshi.dev
        - DOCKERFILE_PATH=/Users/git/statoshi.dev/statoshi.dev
        - BITCOIN_CONF=/Users/git/statoshi.dev/conf/bitcoin.conf
        - BITCOIN_DATA_DIR=/Users/git/.bitcoin
        - STATOSHI_DATA_DIR=/Users/git/.statoshi
        - NOCACHE=
        - VERBOSE=
        - PUBLIC_PORT=80
        - NODE_PORT=8333
        - PASSWORD=changeme
        - CMD_ARGUMENTS=

	[USAGE]: make [COMMAND] [EXTRA_ARGUMENTS]	

		 make init
		 make report
		 make header
		 make build
		 make run
		                       user=root uid=0 nocache=false verbose=false

	[DEV ENVIRONMENT]:	

		 make shell            compiling environment on host machine
		 make signin           ~/GH_TOKEN.txt required from github.com
		 make header package-header
		 make build
		 make build package-statoshi
		 make package-all

	[EXTRA_ARGUMENTS]:	set build variables	

		nocache=true
		            	add --no-cache to docker command and apk add 
		port=integer
		            	set PUBLIC_PORT default 80

		nodeport=integer
		            	set NODE_PORT default 8333

		            	TODO

	[DOCKER COMMANDS]:	push a command to the container	

		cmd=command 	
		cmd="command"	
		             	send CMD_ARGUMENTS to the [TARGET]

	[EXAMPLES]:

		make all run user=root uid=0 no-cache=true verbose=true
		make report all run user=root uid=0 no-cache=true verbose=true cmd="top"
		make a r port=80 no-cache=true verbose=true cmd="ls"

	[COMMAND_LINE]:

	statoshi help              # container command line
	statoshi -d -daemon        # start container bitcoind -daemon
	statoshi debug             # container debug.log output
	statoshi whatami           # container OS profile

	statoshi cli -getmininginfo   # report mining info
	statoshi cli -gettxoutsetinfo # report txo info

	#### WARNING: (effects host datadir) ####
	
	statoshi prune                # default in bitcoin.conf is prune=1 - start pruning node
	
