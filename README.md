## Statoshi: Bitcoin Core + statistics logging

## What is Statoshi?

Statoshi's objective is to protect Bitcoin by bringing transparency to the activity 
occurring on the node network. By making this data available, Bitcoin developers can 
learn more about node performance, gain operational insight about the network, and 
the community can be informed about attacks and aberrant behavior in a timely fashion.

There is a live Grafana dashboard at [statoshi.info](http://statoshi.info)

## License

Statoshi is released under the terms of the MIT license. See [COPYING](COPYING) for more
information or see http://opensource.org/licenses/MIT.

## Development Process

Statoshi's changeset to Bitcoin Core is applied in the `master` branch and is
built and tested after each merge from upstream or from a pull request. However,
it not guaranteed to be completely stable. We do not recommend using Statoshi
as a Bitcoin wallet.

A guide for Statoshi developers is available [here](https://medium.com/@lopp/statoshi-developer-s-guide-241ac9ab9993#.s1rfi3fv6)

## Other Notes

A system metrics daemon is available [here](https://github.com/jlopp/bitcoin-utils/blob/master/systemMetricsDaemon.py)

Statoshi also supports running multiple nodes that emit metrics to a single graphite instance. 
In order to facilitate this, you can add a line to bitcoin.conf that will partition each 
metric by the name of the host: statshostname=yourNodeName--
## Docker Notes & [DigitalOcean.com](https://m.do.co/c/ae5c7d05da91)

## [stats.bitcoincore.dev](https://github.com/bitcoincore-dev/stats.bitcoincore.dev/packages/314536)

#### Full Build

This runs the statoshi configuration and [displays statsd data from the pruned node](http://stats.bitcoincore.dev:3000).

```
docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev
0.20.99             a27f8eb4ad39        4 minutes ago       2.98GB
```

Pull image from the command line:

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev:0.20.99

Use as base image in DockerFile:

	FROM docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev:0.20.99


## [stats.bitcoincore.dev.slim](https://github.com/bitcoincore-dev/stats.bitcoincore.dev/packages/315130)

#### Slim Build

This runs the slim (precompiled signed binaries) configuration and [displays statsd data from the pruned node](http://stats.bitcoincore.dev:3000).

```
docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.slim
0.20.99             390876b14625        24 minutes ago      1.63GB
```
Pull image from the command line:

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.slim:0.20.99

Use as base image in DockerFile:

	FROM docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.slim:0.20.99

## [stats.bitcoincore.dev.gui](https://github.com/bitcoincore-dev/stats.bitcoincore.dev/packages/315116)

#### Gui Build

This runs the gui [(graphite/grafana) configuration](http://stats.bitcoincore.dev:3000) and pulls data from
[http://stats.bitcoincore.dev:8080](http://stats.bitcoincore.dev:8080). Useful as a demo or if you don't want to run your own statoshi instance.

```
docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.gui
0.20.99             737a8acf33c5        About an hour ago   1.23GB
```

Pull image from the command line:

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.gui:0.20.99
	
Use as base image in DockerFile:

	FROM docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.gui:0.20.99

## make help


##### $ <code>make</code>

	Docker:
		make [TARGET] [ARGS]

	Shell:
		make shell user=root

	Targets:

		build-all complete build - no deploy
		run-all  	deploy build-all product

		build-slim	build with signed precompiled statoshi binaries
		run-slim	deploy build-slim product

	ARGS:

	CMD:
		push a shell command to the container

		cmd=:	
		     	   make shell cmd="whoami"
	D:         push a bitcoind command to the container
		d=:  	
		     	   make shell   d="--prune=550"

	USER:       
	           make            
	           make user=<user>
	                            result: stats.bitcoincore.dev_0


	PROJECT_NAME         = stats.bitcoincore.dev


	PWD                  = /Users/git/stats.bitcoincore.dev
	THIS_FILE            = /Users/git/stats.bitcoincore.dev/GNUmakefile

	DOCKERFILE           = /Users/git/stats.bitcoincore.dev/stats.bitcoincore.dev
	DOCKERFILE_SLIM      = /Users/git/stats.bitcoincore.dev/stats.bitcoincore.dev.slim
	DOCKERFILE_GUI       = /Users/git/stats.bitcoincore.dev/stats.bitcoincore.dev.gui
	DOCKERFILE_SHELL     = /Users/git/stats.bitcoincore.dev/shell

	DOCKER_COMPOSE       = /Users/git/stats.bitcoincore.dev/docker-compose.yml

	SERVICE_TARGET       = shell (default)

	HOST_USER            = root
	HOST_UID             = 0

	CMD_ARGUMENTS        = ls -a
	D_ARGUMENTS          = --disable-wallet
	CLI_ARGUMENTS        = stop





