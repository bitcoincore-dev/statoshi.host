# REF: https://github.com/LINKIT-Group/dockerbuild/blob/master/Makefile
# Make searches for this file first per make default search hierarchy
THIS_FILE								:= $(lastword $(MAKEFILE_LIST))
export THIS_FILE
TIME									:= $(shell date +%s)
export TIME

ifeq ($(user),)
## USER retrieved from env, UID from shell.
HOST_USER								?=  $(strip $(if $(USER),$(USER),nodummy))
HOST_UID								?=  $(strip $(if $(shell id -u),$(shell id -u),4000))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER								= $(user)
HOST_UID								= $(strip $(if $(uid),$(uid),0))
endif
export HOST_USER
export HOST_UID

# Note the different service configs in docker-compose.yml.
# We override this default for different build/run configs
ifeq ($(target),)
SERVICE_TARGET							?= shell
else
SERVICE_TARGET							:= $(target)
endif
export SERVICE_TARGET

ifeq ($(alpine),)
ALPINE_VERSION							:= 3.11.10
else
ALPINE_VERSION							:= $(alpine)
endif
export ALPINE_VERSION

ifeq ($(whisper),)
WHISPER_VERSION							:= 1.1.7
else
WHISPER_VERSION							:= $(grafana)
endif
export WHISPER_VERSION

ifeq ($(carbon),)
CARBON_VERSION							:= 1.1.7
else
CARBON_VERSION							:= $(carbon)
endif
export CARBON_VERSION

ifeq ($(graphite),)
GRAPHITE_VERSION						:= 1.1.7
else
GRAPHITE_VERSION						:= $(graphite)
endif
export GRAPHITE_VERSION

ifeq ($(statsd),)
STATSD_VERSION							:= 0.8.6
else
STATSD_VERSION							:= $(statsd)
endif
export STATSD_VERSION

#ifeq ($(grafana),)
#GRAFANA_VERSION							:= 7.0.0
#else
#GRAFANA_VERSION							:= $(grafana)
#endif
#export GRAFANA_VERSION

# PROJECT_NAME defaults to name of the current directory.
PROJECT_NAME							:= $(notdir $(PWD))
export PROJECT_NAME

#GIT CONFIG
GIT_USER_NAME							:= $(shell git config user.name)
export GIT_USER_NAME
GIT_USER_EMAIL							:= $(shell git config user.email)
export GIT_USER_EMAIL
GIT_SERVER								:= https://github.com
export GIT_SERVER
GIT_PROFILE								:= bitcoincore-dev
export GIT_PROFILE
GIT_BRANCH								:= $(shell git rev-parse --abbrev-ref HEAD)
export GIT_BRANCH
GIT_HASH								:= $(shell git rev-parse HEAD)
export GIT_HASH
GIT_REPO_ORIGIN							:= $(shell git remote get-url origin)
export GIT_REPO_ORIGIN
GIT_REPO_NAME							:= $(PROJECT_NAME)
export GIT_REPO_NAME
GIT_REPO_PATH							:= ~/$(GIT_REPO_NAME)
export GIT_REPO_PATH
ifeq ($(slim),true)
DOCKERFILE_BODY							:= docker/statoshi.slim
else
DOCKERFILE_BODY							:= docker/statoshi.all
endif
export DOCKERFILE_BODY
DOCKERFILE								:= $(PROJECT_NAME)
export DOCKERFILE
DOCKERFILE_PATH							:= ~/$(PROJECT_NAME)/$(DOCKERFILE)
export DOCKERFILE_PATH
BITCOIN_CONF							:= ~/$(PROJECT_NAME)/conf/bitcoin.conf
export BITCOIN_CONF

ifneq ($(bitcoin-datadir),)
BITCOIN_DATA_DIR						:= $(bitcoin-datadir)
else
BITCOIN_DATA_DIR						:= ~/.bitcoin
endif
export BITCOIN_DATA_DIR

STATOSHI_DATA_DIR						:= ~/.statoshi
export STATOSHI_DATA
#REF: https://github.com/getumbrel/umbrel/blob/master/apps/README.md
#- ${APP_DATA_DIR}/data:/data

ifeq ($(no-cache),true)
NO_CACHE								:= --no-cache
else
NO_CACHE								:=	
endif
export NO_CACHE

ifeq ($(verbose),true)
VERBOSE									:= --verbose
else
VERBOSE									:=	
endif
export VERBOSE

ifeq ($(port),)
PUBLIC_PORT								:= 80
else
PUBLIC_PORT								:= $(port)
endif
export PUBLIC_PORT

ifneq ($(passwd),)
PASSWORD								:= $(passwd)
else 
PASSWORD								:= changeme
endif
export PASSWORD

ifeq ($(cmd),)
CMD_ARGUMENTS							:= 	
else
CMD_ARGUMENTS							:= $(cmd)
endif
export CMD_ARGUMENTS

# ref: https://github.com/linkit-group/dockerbuild/blob/master/makefile
# if you see pwd_unknown showing up, check user permissions.
#todo: more umbrel support
#todo: umbrel root no good
#todo: ref: https://github.com/getumbrel/umbrel/blob/master/security.md
ifeq ($(umbrel),true)
#comply with umbrel conventions
PWD=/home/umbrel/umbrel/apps/stats.bitcoincore.dev
UMBREL=true
export PWD
export UMBREL
else
pwd ?= pwd_unknown
endif

.PHONY: help
help: report
	@echo ''
	@echo '	[USAGE]:	make [BUILD] run [EXTRA_ARGUMENTS]	'
	@echo ''
	@echo '		make all run user=root uid=0 no-cache=true verbose=true'
	@echo ''
	@echo '	[DEV ENVIRONMENT]:	'
	@echo ''
	@echo '		shell user=root'
	@echo '		shell user=$(HOST_USER)'
	@echo ''
	@echo '	[BUILD]:	'
	@echo ''
	@echo '		all'
	@echo '		            	compile statoshi source code'
	@echo '		slim'
	@echo '		            	deploy slim product'
	@echo ''
	@echo '	[EXTRA_ARGUMENTS]:	set build variables	'
	@echo ''
	@echo '		no-cache=true'
	@echo '		            	add --no-cache to docker command and apk add $(NO_CACHE)'
	@echo '		port=integer'
	@echo '		            	set PUBLIC_PORT default 80'
	@echo ''
	@echo '		            	TODO'
	@echo ''
	@echo '	[DOCKER COMMANDS]:	push a command to the container	'
	@echo ''
	@echo '		cmd=command 	'
	@echo '		cmd="command"	'
	@echo '		             	send CMD_ARGUMENTS to the [TARGET]'
	@echo ''
	@echo '	[EXAMPLE]:'
	@echo ''
	@echo '		make all run user=root uid=0 no-cache=true verbose=true'
	@echo '		make report all run user=root uid=0 no-cache=true verbose=true cmd="top"'
	@echo '		make a r port=80 no-cache=true verbose=true cmd="ls"'
	@echo ''
	@echo '	[COMMAND_LINE]:'
	@echo ''
	@echo '	stats-console              # container command line'
	@echo '	stats-bitcoind             # start container bitcoind -daemon'
	@echo '	stats-debug                # container debug.log output'
	@echo '	stats-whatami              # container OS profile'
	@echo ''
	@echo '	stats-cli -getmininginfo   # report mining info'
	@echo '	stats-cli -gettxoutsetinfo # report txo info'
	@echo ''
	@echo '	#### WARNING: (effects host datadir) ####'
	@echo '	'
	@echo '	stats-prune                # default in bitcoin.conf is prune=1 - start pruning node'
	@echo '	'

.PHONY: report
report:
	@echo ''
	@echo '	[ARGUMENTS]	'
	@echo '      args:'
	@echo '        - PWD=${PWD}'
	@echo '        - UMBREL=${UMBREL}'
	@echo '        - THIS_FILE=${THIS_FILE}'
	@echo '        - TIME=${TIME}'
	@echo '        - HOST_USER=${HOST_USER}'
	@echo '        - HOST_UID=${HOST_UID}'
	@echo '        - SERVICE_TARGET=${SERVICE_TARGET}'
	@echo '        - ALPINE_VERSION=${ALPINE_VERSION}'
	@echo '        - WHISPER_VERSION=${WHISPER_VERSION}'
	@echo '        - CARBON_VERSION=${CARBON_VERSION}'
	@echo '        - GRAPHITE_VERSION=${GRAPHITE_VERSION}'
	@echo '        - STATSD_VERSION=${STATSD_VERSION}'
	@echo '        - GRAFANA_VERSION=${GRAFANA_VERSION}'
	@echo '        - PROJECT_NAME=${PROJECT_NAME}'
	@echo '        - GIT_USER_NAME=${GIT_USER_NAME}'
	@echo '        - GIT_USER_EMAIL=${GIT_USER_EMAIL}'
	@echo '        - GIT_SERVER=${GIT_SERVER}'
	@echo '        - GIT_PROFILE=${GIT_PROFILE}'
	@echo '        - GIT_BRANCH=${GIT_BRANCH}'
	@echo '        - GIT_HASH=${GIT_HASH}'
	@echo '        - GIT_REPO_ORIGIN=${GIT_REPO_ORIGIN}'
	
	@echo '        - GIT_REPO_PATH=${GIT_REPO_PATH}'

#######################
# Backup $HOME/.bitcoin
########################
#backup:
#	@echo ''
#	bash -c 'mkdir -p $(HOME)/.bitcoin'
##	bash -c 'conf/get_size.sh'
#	bash -c 'tar czv --exclude=*.log --exclude=banlist.dat \
#			--exclude=fee_exstimates.dat --exclude=mempool.dat \
#			--exclude=peers.dat --exclude=.cookie --exclude=database \
#			--exclude=.lock --exclude=.walletlock --exclude=.DS_Store\
#			-f $(HOME)/.bitcoin-$(TIME).tar.gz $(HOME)/.bitcoin'
#	bash -c 'openssl md5 $(HOME)/.bitcoin-$(TIME).tar.gz > $(HOME)/bitcoin-$(TIME).tar.gz.md5'
#	bash -c 'openssl md5 -c $(HOME)/bitcoin-$(TIME).tar.gz.md5'
#	@echo ''

#######################
# Some initial setup
########################
.PHONY: init
init: report
	@echo 'init'
	git config --global core.editor vim
	bash -c 'mkdir -p $(BITCOIN_DATA_DIR)'
	bash -c 'mkdir -p $(STATOSHI_DATA_DIR)'
	bash -c 'sudo mkdir -p /usr/local/bin'
	bash -c 'sudo mkdir -p /usr/local/include'
	bash -c 'install -v $(PWD)/conf/usr/local/bin/*  /usr/local/bin/'
	@echo ''
	#bash -c '$(GIT_REPO_PATH)/conf/config.bitcoin.conf.sh'
	@echo ''
	bash -c 'install -v $(PWD)/conf/bitcoin.conf    $(STATOSHI_DATA_DIR)/bitcoin.conf'
	bash -c 'install -v $(PWD)/conf/additional.conf $(STATOSHI_DATA_DIR)/additional.conf'
	bash -c 'install -v $(PWD)/docker/docker-compose.yml .'
	bash -c '[ -d /usr/local/include/statsd-client-cpp ] || git clone -b master --depth 1  https://github.com/bitcoincore-dev/statsd-client-cpp.git /usr/local/include/statsd-client-cpp'
	@echo ''
	bash -c 'cat $(PWD)/docker/header               > $(DOCKERFILE)'
	bash -c 'cat $(PWD)/$(DOCKERFILE_BODY)         >> $(DOCKERFILE)'
	bash -c 'cat $(PWD)/docker/footer              >> $(DOCKERFILE)'
	bash -c 'cat $(PWD)/docker/torproxy             > torproxy'
	@echo ''
#######################
.PHONY: build-shell
build-shell:
	@echo ''
	bash -c '$(pwd) cat ./docker/shell                > shell'
	docker-compose $(VERBOSE) build $(NO_CACHE) shell
	@echo ''
#######################
.PHONY: shell
shell: report build-shell
	@echo 'shell'
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	@echo ''
	docker-compose --verbose -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh
	@echo ''
else
	# run the command
	@echo ''
	docker-compose --verbose -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "$(CMD_ARGUMENTS)"
	@echo ''
endif
#######################
.PHONY: build-header
build-header:
	@echo ''
	docker-compose $(VERBOSE) build $(NO_CACHE) header
	@echo ''
#######################
.PHONY: header
header: report build-header
	@echo 'header'
	@echo ''
	docker-compose $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run header sh
	@echo ''
#######################
.PHONY: test
test:
	@echo 'test'
	docker-compose $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run -d --rm shell sh -c '\
	echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success
	@echo ''
#######################
.PHONY: build
build: report
	@echo 'build'
	docker-compose $(VERBOSE) $(NO_CACHE)  build $(NO_CACHE) statoshi
	@echo ''
#######################
.PHONY: run
run:
	@echo 'run'
ifeq ($(CMD_ARGUMENTS),)
	@echo ''
	docker-compose $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run -d --publish $(PUBLIC_PORT):3000 --publish 8125:8125 --publish 8126:8126 --publish 8333:8333 --publish 8332:8332 statoshi sh
	@echo ''
else
	@echo ''
	docker-compose $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run -d --publish $(PUBLIC_PORT):3000 --publish 8125:8125 --publish 8126:8126 --publish 8333:8333 --publish 8332:8332 statoshi sh -c "$(CMD_ARGUMENTS)"
	@echo ''
endif
	@echo 'Give grafana a few minutes to set up...'
	@echo 'http://localhost:$(PUBLIC_PORT)'
#######################
.PHONY: extract
extract:
	@echo 'extract'
	#extract TODO CREATE PACKAGE for distribution
	sed '$d' $(DOCKERFILE) | sed '$d' | sed '$d' > $(DOCKERFILE_EXTRACT)
	docker build -f $(DOCKERFILE_EXTRACT) --rm -t $(DOCKERFILE_EXTRACT) .
	docker run --name $(DOCKERFILE_EXTRACT) $(DOCKERFILE_EXTRACT) /bin/true
	docker rm $(DOCKERFILE_EXTRACT)
	rm -f  $(DOCKERFILE_EXTRACT)
#######################
.PHONY: torproxy
torproxy:
	@echo ''
	#REF: https://hub.docker.com/r/dperson/torproxy
	#bash -c 'docker run -it -p 8118:8118 -p 9050:9050 -p 9051:9051 -d dperson/torproxy'
	@echo ''
	docker-compose $(VERBOSE) -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --publish 8118:8118 --publish 9050:9050  --publish 9051:9051 --rm torproxy sh -c "$(CMD_ARGUMENTS)"
	@echo ''
#######################
.PHONY: clean
clean:
	# remove created images
	@docker-compose -p $(PROJECT_NAME)_$(HOST_UID) down --remove-orphans --rmi all 2>/dev/null \
	&& echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" removed.' \
	|| echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" already removed.'
	@rm -f $(DOCKERFILE)*
	@rm -f shell
	@rm -f torproxy
	@rm -f Makefile
#######################
.PHONY: prune
prune:
	@echo 'prune'
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) down
	docker system prune -af
#######################
.PHONY: prune-network
prune-network:
	@echo 'prune-network'
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) down
	docker network prune -f
#######################
.PHONY: docs
docs:
#$ make report no-cache=true verbose=true cmd='make doc' user=root doc
	@echo 'docs'
	export HOST_USER=root
	export HOST_UID=0
	bash -c 'cat ./docker/README.md > README.md'
	bash -c 'cat ./docker/DOCKER.md >> README.md'
	bash -c 'make help >> README.md'
	bash -c 'make report >> README.md'
#######################
package-all:
	bash -c 'cat ~/GH_TOKEN.txt | docker login docker.pkg.github.com -u RandyMcMillan --password-stdin'
	bash -c 'docker tag $(PROJECT_NAME):root docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/$(notdir $(PROJECT_NAME)).all:root'
	bash -c 'docker push docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/$(notdir $(PROJECT_NAME)):root'
#######################
package-slim:
	bash -c 'cat ~/GH_TOKEN.txt | docker login docker.pkg.github.com -u RandyMcMillan --password-stdin'
	bash -c 'docker tag $(PROJECT_NAME):root docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/$(notdir $(PROJECT_NAME)).slim:root'
	bash -c 'docker push docker.pkg.github.com/bitcoincore-dev/stats.bitcoincore.dev/$(notdir $(PROJECT_NAME)).slim:root'
#######################
-include funcs.mk
-include Makefile

