### Install make docker docker-compose

#### Linux:
```
apt-get install build-essential docker-ce docker-ce-cli containerd.io
```

#### macOS:
```
brew install make --cask docker
```

### Run:

```
git clone https://github.com/bitcoincore-dev/stats.bitcoincore.dev
cd stats.bitcoincore.dev
make help

```

### OpenGPG: [signature](./conf/usr/local/bin/randymcmillan.asc)

##### $ <code>stats-\<command></code> <code>commands assume image is most recent container</code>

```
stats-console              # container command line
stats-bitcoind             # start container bitcoind -daemon
stats-debug                # container debug.log output
stats-whatami              # container OS profile
```

```
stats-cli -getmininginfo   # report mining info
stats-cli -gettxoutsetinfo # report txo info
```

#### WARNING: (effects host datadir)

```
stats-prune                # default in bitcoin.conf is prune=1 - start pruning node

```

---

## [stats.bitcoincore.dev](https://github.com/bitcoincore-dev/stats.bitcoincore.dev/packages) packages

#### Full Build

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev:root

Pull image from the command line:

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev:root

Use as base image in DockerFile:

	FROM docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev:root

#### Slim Build

This runs the slim (precompiled signed binaries) configuration and [displays statsd data from the pruned node](http://stats.bitcoincore.dev:3000).

Pull image from the command line:

	docker pull docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.slim:root

Use as base image in DockerFile:

	FROM docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/stats.bitcoincore.dev.slim:root

---
