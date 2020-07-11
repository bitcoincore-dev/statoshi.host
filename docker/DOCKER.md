

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