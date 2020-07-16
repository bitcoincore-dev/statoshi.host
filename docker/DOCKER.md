--
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
