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
metric by the name of the host: statshostname=yourNodeName

--
## Make Notes


### $ <code>make</code>

  Usage:	make [TARGET] [EXTRA_ARGUMENTS]

  Targets:

  	build	    build docker --image-- for current user: root(uid=0)
  	rebuild	    rebuild docker --image-- for current user: root(uid=0)
  	test	    test docker --container-- for current user: root(uid=0)
  	service	    run as service --container-- for current user: root(uid=0)
  	login	    run as service and login --container-- for current user: root(uid=0)
  	clean	    remove docker --image-- for current user: root(uid=0)
  	prune	    shortcut for docker system prune -af. Cleanup inactive containers and cache.

  Shell:

  	shell	    run a docker image with stats.bitcoincore.dev as a volume at /home/root/stats.bitcoincore.dev
  	shell	    run docker --container-- for current user: root(uid=0)




  Extra:

  	cmd=:	    make user=root shell cmd="whoami"
  	-----	    ---------------------------
  	user=	    overrides ＄(user)
  	user=:	    make shell user=root (root default uid=0)
  	uid=	    overrides current user uid.
  	uid=:	    make shell user=git uid=4000 (default 0 if user= set)


--
## Docker Notes & [DigitalOcean.com](https://m.do.co/c/ae5c7d05da91)