![Statoshi](http://lopp.net/images/statoshi.png)
# Installation and Dependencies
_NOTE: This guide has only been tested on Ubuntu; if you run into issues installing, please contact @jlopp_

1) Install [node.js](http://nodejs.org/download/)

2) Install [Forever](http://blog.nodejitsu.com/keep-a-nodejs-server-up-with-forever/)
    sudo npm install forever

3) Install [StatsD](https://github.com/etsy/statsd).

Create a config.js file copied from /opt/statsd/exampleConfig.js; at the minimum it should contain:

```
    {
        graphitePort: 2003
        , graphiteHost: "127.0.0.1"
        , port: 8125
        , backends: [ "./backends/graphite" ]
    }
```

Start statsd:
    forever start /opt/statsd/stats.js /opt/statsd/config.js

4) [Download](https://httpd.apache.org/download.cgi) and install Apache HTTPD Server. If you’re running Linux, it’s probably easier to install via your package manager.

5) Install software to visualize the stats collected by StatsD. We recommend [Graphite](http://graphite.wikidot.com/installation). Make sure you install a version newer than 0.9.12 for [maximum Grafana performance.](http://grafana.org/docs/performance/)
For Graphite, once you have it installed you’ll want to configure how it stores the data from StatsD, in the graphite/conf/storage-schemas.conf:

    [carbon]
    pattern = ^carbon\.
    retentions = 10:2160,60:10080,600:262974
    
    [stats]
    priority = 110
    pattern = ^stats\..*
    retentions = 10:2160,60:10080,600:262974
    
    [default]
    pattern = .*
    retentions = 10:2160,60:10080,600:262974

To prevent loss of sparse data you'll also need to modify Graphite's graphite/conf/storage-aggregation.conf:

    [min]
    pattern = \.min$
    xFilesFactor = 0.0
    aggregationMethod = min
    
    [max]
    pattern = \.max$
    xFilesFactor = 0.0
    aggregationMethod = max
    
    [sum]
    pattern = \.count$
    xFilesFactor = 0.0
    aggregationMethod = sum
    
    [default_average]
    pattern = .*
    xFilesFactor = 0.0
    aggregationMethod = average

Run the carbon cache for Graphie:

    sudo /opt/graphite/bin/carbon-cache.py start

Optional performance improvement: install [memcached](http://www.memcached.org/downloads)

    sudo apt-get install memcached

Enabled memcached in /opt/graphite/webapp/graphite/local_settings.py

    MEMCACHE_HOSTS = ['127.0.0.1:11211']
    DEFAULT_CACHE_DURATION = 600

6) Download (or git clone) the Statoshi fork:
```
    jameson@lopp:~/workspace/$ git clone https://github.com/jlopp/statoshi.git
    Cloning into ‘statoshi’…
    remote: Reusing existing pack: 35655, done.
    remote: Total 35655 (delta 0), reused 0 (delta 0)
    Receiving objects: 100% (35655/35655), 26.56 MiB | 2.37 MiB/s, done.
    Resolving deltas: 100% (25766/25766), done.
    Checking connectivity… done
```

7) Compile the project. This can be a bit tricky if it's your first time due to the dependencies; you'll likely want to read the documentation:
* Linux build notes are [here](https://github.com/jlopp/statoshi/blob/master/doc/build-unix.md)
* OSX build notes are [here](https://github.com/jlopp/statoshi/blob/master/doc/build-osx.md)
* Windows build notes are [here](https://github.com/jlopp/statoshi/blob/master/doc/build-msw.md)

Once you think you have all of the dependencies installed, build the project. For Linux, the commands are:
```
    jameson@lopp:~/$ cd /path/to/statoshi/
    jameson@lopp:~/workspace/statoshi/$ ./autogen.sh
    jameson@lopp:~/workspace/statoshi/$ ./configure
    jameson@lopp:~/workspace/statoshi/$ make
```

It may take 20+ minutes to build, depending upon the speed of your computer. If you’re missing a dependency, you should receive an error noting what is missing.

Note that the Statoshi project assumes that you are running StatsD on the same machine as your Bitcoin node. If you wish to run StatsD on a different machine or non-default port, you’ll need to edit the default configuration on line 16 of **/statoshi/src/statsd_client.h** before building the project.

8) Set some values in your bitcoin.conf file; the 'gettxoutsetinfo' command ensures that UTXO metrics get populated after each new block arrives. The same goes for the 'getmininginfo' command. Note that you probably don't want to set the blocknotify command until your node is synced to the chain tip, otherwise it will slow down the node's initial sync.
```
rpcuser=unguessableUser3256
rpcpassword=someRandomPasswordWithEntropyHere
blocknotify=/path/to/bitcoin-cli getmininginfo && sleep 10 && /path/to/bitcoin-cli getchaintxstats && sleep 10 && /path/to/bitcoin-cli gettxoutsetinfo
```

9) Set the various necessary services to automatically start on machine boot, via /etc/crontab entries:
```
@reboot /usr/bin/python /opt/graphite/bin/carbon-cache.py start
@reboot /usr/local/bin/forever start /home//statsd/stats.js /home//statsd/config.js
@reboot /usr/bin/python /home//logSystemMetrics.py &
@reboot /usr/bin/bitcoind -daemon
```

10) Start your Statoshi node (either the GUI or the command line daemon) - the Linux commands for them are:
```
    GUI: /path/to/statoshi/src/qt/bitcoin-qt &
    Daemon: /path/to/statoshi/src/bitcoind -daemon
```
Now you can check out the stats as they roll in to Graphite; you should see graphs begin to be populated within 30 seconds!

11) If you wish to duplicate the UI on [statoshi.info](http://statoshi.info), you'll also need to install Grafana. You can find [installation instructions here](http://docs.grafana.org/installation/).

Since Graphite runs on port 3000, you can have Apache proxy requests to it by:

```
    jameson@lopp:~/$ sudo a2enmod proxy 
    jameson@lopp:~/$ sudo a2enmod proxy_http
```

Add to apache2.conf:
```
    <VirtualHost *:80>
    ProxyPreserveHost On
    ProxyRequests Off
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/
    </VirtualHost>
```
Restart Apache: sudo service apache2 restart

Once you install Grafana, you can load the dashboards from [statoshi.info](http://statoshi.info) by clicking on the 'settings' icon in the upper left of statoshi.info and selecting "View JSON." Then import the JSON into your own Statoshi instance. The home dashboard is a special case - it can only be modified by updating the json file located at
/usr/share/grafana/public/dashboards/home.json
