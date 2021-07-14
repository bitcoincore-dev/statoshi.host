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
## [statoshi.dev](https://github.com/randymcmillan/statoshi.dev) [72bcc0b08](https://github.com/randymcmillan/statoshi.dev/commit/72bcc0b08)
##### &#36; <code>make</code>

	[USAGE]:	make [BUILD] run [EXTRA_ARGUMENTS]	

		make init header build run user=root uid=0 nocache=false verbose=true

	[DEV ENVIRONMENT]:	

		make header user=root
		make shell  user=root
		make shell  user=root

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

	[EXAMPLE]:

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
	
	stats-prune                # default in bitcoin.conf is prune=1 - start pruning node
	
