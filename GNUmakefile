# REF: https://github.com/LINKIT-Group/dockerbuild/blob/master/Makefile
# Make searches for this file first per make default search hierarchy

SHELL := /bin/bash

PWD 									?= pwd_unknown

THIS_FILE								:= $(lastword $(MAKEFILE_LIST))
export THIS_FILE
TIME									:= $(shell date +%s)
export TIME

ifeq ($(user),)
HOST_USER								:= root
HOST_UID								:= $(strip $(if $(uid),$(uid),0))
else
HOST_USER								:=  $(strip $(if $(USER),$(USER),nodummy))
HOST_UID								:=  $(strip $(if $(shell id -u),$(shell id -u),4000))
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

ifeq ($(docker),)
#DOCKER							        := $(shell find /usr/local/bin -name 'docker')
DOCKER							        := $(shell which docker)
else
DOCKER   							:= $(docker)
endif
export DOCKER

ifeq ($(compose),)
#DOCKER_COMPOSE						        := $(shell find /usr/local/bin -name 'docker-compose')
DOCKER_COMPOSE						        := $(shell which docker-compose)
else
DOCKER_COMPOSE							:= $(compose)
endif
export DOCKER_COMPOSE

ifeq ($(alpine),)
ALPINE_VERSION							:= 3.11.6
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

ifeq ($(grafana),)
GRAFANA_VERSION							:= 7.0.0
else
GRAFANA_VERSION							:= $(grafana)
endif
export GRAFANA_VERSION

ifeq ($(django),)
DJANGO_VERSION							:= 2.2.24
else
DJANGO_VERSION							:= $(django)
endif
export DJANGO_VERSION

# PROJECT_NAME defaults to name of the current directory.
ifeq ($(project),)
PROJECT_NAME							:= $(notdir $(PWD))
else
PROJECT_NAME							:= $(project)
endif
export PROJECT_NAME

#GIT CONFIG
GIT_USER_NAME							:= $(shell git config user.name)
export GIT_USER_NAME
GIT_USER_EMAIL							:= $(shell git config user.email)
export GIT_USER_EMAIL
GIT_SERVER								:= https://github.com
export GIT_SERVER

GIT_REPO_NAME							:= $(PROJECT_NAME)
export GIT_REPO_NAME

ifeq ($(GIT_REPO_NAME),statoshi.dev)
GIT_PROFILE								:= randymcmillan
export GIT_PROFILE
endif
ifeq ($(GIT_REPO_NAME),statoshi.host)
GIT_PROFILE								:= bitcoincore-dev
export GIT_PROFILE
endif

GIT_BRANCH								:= $(shell git rev-parse --abbrev-ref HEAD)
export GIT_BRANCH
GIT_HASH								:= $(shell git rev-parse --short HEAD)
export GIT_HASH
GIT_PREVIOUS_HASH						:= $(shell git rev-parse --short master@{1})
export GIT_PREVIOUS_HASH
GIT_REPO_ORIGIN							:= $(shell git remote get-url origin)
export GIT_REPO_ORIGIN
GIT_REPO_PATH							:= $(HOME)/$(GIT_REPO_NAME)
export GIT_REPO_PATH

#TODO imp build type better
ifeq ($(slim),true)
DOCKER_BUILD_TYPE						:= slim
export DOCKER_BUILD_TYPE
DOCKERFILE_BODY							:= docker/statoshi.$(DOCKER_BUILD_TYPE)
SLIM                                    := $(slim)
else
DOCKER_BUILD_TYPE						:= all
export DOCKER_BUILD_TYPE
DOCKERFILE_BODY							:= docker/statoshi.$(DOCKER_BUILD_TYPE)
SLIM                                    := false
endif
export DOCKERFILE_BODY
export SLIM
DOCKERFILE								:= $(PROJECT_NAME)
export DOCKERFILE
DOCKERFILE_PATH							:= $(HOME)/$(PROJECT_NAME)/$(DOCKERFILE)
export DOCKERFILE_PATH
BITCOIN_CONF							:= $(HOME)/$(PROJECT_NAME)/conf/bitcoin.conf
export BITCOIN_CONF

ifneq ($(bitcoin-datadir),)
BITCOIN_DATA_DIR						:= $(bitcoin-datadir)
else
BITCOIN_DATA_DIR						:= $(HOME)/.bitcoin
endif
export BITCOIN_DATA_DIR

STATOSHI_DATA_DIR						:= $(HOME)/.statoshi
export STATOSHI_DATA_DIR
#REF: https://github.com/getumbrel/umbrel/blob/master/apps/README.md
#- ${APP_DATA_DIR}/data:/data

ifeq ($(nocache),true)
NOCACHE								:= --no-cache
else
NOCACHE								:=	
endif
export NOCACHE

ifeq ($(verbose),true)
VERBOSE									:= --verbose
else
VERBOSE									:=	
endif
export VERBOSE


#TODO more umbrel config testing
ifeq ($(port),)
PUBLIC_PORT								:= 80
else
PUBLIC_PORT								:= $(port)
endif
export PUBLIC_PORT

ifeq ($(nodeport),)
NODE_PORT								:= 8333
else
NODE_PORT								:= $(nodeport)
endif
export NODE_PORT

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
PWD=/home/umbrel/umbrel/apps/$(PROJECT_NAME)
UMBREL=true
else
pwd ?= pwd_unknown
UMBREL=false
endif
export PWD
export UMBREL
#######################

.PHONY: help
help:
	@echo ''
	@echo '	[USAGE]:	make [BUILD] run [EXTRA_ARGUMENTS]	'
	@echo ''
	@echo '		make init header build run user=root uid=0 nocache=false verbose=true'
	@echo ''
	@echo '	[DEV ENVIRONMENT]:	'
	@echo ''
	@echo '		make header user=root'
	@echo '		make shell  user=root'
	@echo '		make shell  user=$(HOST_USER)'
	@echo ''
	@echo '	[EXTRA_ARGUMENTS]:	set build variables	'
	@echo ''
	@echo '		nocache=true'
	@echo '		            	add --no-cache to docker command and apk add $(NOCACHE)'
	@echo '		port=integer'
	@echo '		            	set PUBLIC_PORT default 80'
	@echo ''
	@echo '		nodeport=integer'
	@echo '		            	set NODE_PORT default 8333'
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
	@echo '	statoshi help              # container command line'
	@echo '	statoshi -d -daemon        # start container bitcoind -daemon'
	@echo '	statoshi debug             # container debug.log output'
	@echo '	statoshi whatami           # container OS profile'
	@echo ''
	@echo '	statoshi cli -getmininginfo   # report mining info'
	@echo '	statoshi cli -gettxoutsetinfo # report txo info'
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
	@echo '        - HOME=${HOME}'
	@echo '        - PWD=${PWD}'
	@echo '        - UMBREL=${UMBREL}'
	@echo '        - THIS_FILE=${THIS_FILE}'
	@echo '        - TIME=${TIME}'
	@echo '        - HOST_USER=${HOST_USER}'
	@echo '        - HOST_UID=${HOST_UID}'
	@echo '        - PUBLIC_PORT=${PUBLIC_PORT}'
	@echo '        - NODE_PORT=${NODE_PORT}'
	@echo '        - SERVICE_TARGET=${SERVICE_TARGET}'
	@echo '        - ALPINE_VERSION=${ALPINE_VERSION}'
	@echo '        - WHISPER_VERSION=${WHISPER_VERSION}'
	@echo '        - CARBON_VERSION=${CARBON_VERSION}'
	@echo '        - GRAPHITE_VERSION=${GRAPHITE_VERSION}'
	@echo '        - STATSD_VERSION=${STATSD_VERSION}'
	@echo '        - GRAFANA_VERSION=${GRAFANA_VERSION}'
	@echo '        - DJANGO_VERSION=${DJANGO_VERSION}'
	@echo '        - PROJECT_NAME=${PROJECT_NAME}'
	@echo '        - DOCKER_BUILD_TYPE=${DOCKER_BUILD_TYPE}'
	@echo '        - SLIM=${SLIM}'
	@echo '        - DOCKER_COMPOSE=${DOCKER_COMPOSE}'
	@echo '        - DOCKERFILE=${DOCKERFILE}'
	@echo '        - DOCKERFILE_BODY=${DOCKERFILE_BODY}'
	@echo '        - GIT_USER_NAME=${GIT_USER_NAME}'
	@echo '        - GIT_USER_EMAIL=${GIT_USER_EMAIL}'
	@echo '        - GIT_SERVER=${GIT_SERVER}'
	@echo '        - GIT_PROFILE=${GIT_PROFILE}'
	@echo '        - GIT_BRANCH=${GIT_BRANCH}'
	@echo '        - GIT_HASH=${GIT_HASH}'
	@echo '        - GIT_PREVIOUS_HASH=${GIT_PREVIOUS_HASH}'
	@echo '        - GIT_REPO_ORIGIN=${GIT_REPO_ORIGIN}'
	@echo '        - GIT_REPO_NAME=${GIT_REPO_NAME}'
	@echo '        - GIT_REPO_PATH=${GIT_REPO_PATH}'
	@echo '        - DOCKERFILE=${DOCKERFILE}'
	@echo '        - DOCKERFILE_PATH=${DOCKERFILE_PATH}'
	@echo '        - BITCOIN_CONF=${BITCOIN_CONF}'
	@echo '        - BITCOIN_DATA_DIR=${BITCOIN_DATA_DIR}'
	@echo '        - STATOSHI_DATA_DIR=${STATOSHI_DATA_DIR}'
	@echo '        - NOCACHE=${NOCACHE}'
	@echo '        - VERBOSE=${VERBOSE}'
	@echo '        - PUBLIC_PORT=${PUBLIC_PORT}'
	@echo '        - NODE_PORT=${NODE_PORT}'
	@echo '        - PASSWORD=${PASSWORD}'
	@echo '        - CMD_ARGUMENTS=${CMD_ARGUMENTS}'

#######################

ORIGIN_DIR:=$(PWD)
MACOS_TARGET_DIR:=/var/root/$(PROJECT_NAME)
LINUX_TARGET_DIR:=/root/$(PROJECT_NAME)
export ORIGIN_DIR
export TARGET_DIR

.PHONY: super
super:
ifneq ($(shell id -u),0)
	@echo switch to superuser
	@echo cd $(TARGET_DIR)
	#sudo ln -s $(PWD) $(TARGET_DIR)
#.ONESHELL:
	sudo -s
endif
#######################
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
#######################

.PHONY: host
host:
	@echo 'host'
	bash -c './host'

#######################
.PHONY: init
init: report
ifneq ($(shell id -u),0)
	@echo 'sudo make init #try if permissions issue'
endif
	@echo 'init'
	git config --global core.editor vim
ifeq ($(slim),true)
	bash -c 'cat $(PWD)/$(DOCKERFILE_BODY)			 > $(PWD)/$(DOCKERFILE)'
	docker pull ghcr.io/randymcmillan/statoshi.dev/header-root:latest
else
	bash -c 'cat $(PWD)/docker/header				 > $(PWD)/$(DOCKERFILE)'
	bash -c 'cat $(PWD)/$(DOCKERFILE_BODY)			>> $(PWD)/$(DOCKERFILE)'
endif
	bash -c 'cat $(PWD)/docker/footer				>> $(PWD)/$(DOCKERFILE)'
	bash -c 'cat $(PWD)/docker/torproxy				> $(PWD)/torproxy'
	bash -c 'cat $(PWD)/docker/shell				> $(PWD)/shell'
	@echo ''
	bash -c 'mkdir -p $(BITCOIN_DATA_DIR)'
	bash -c 'mkdir -p $(STATOSHI_DATA_DIR)'
	bash -c 'mkdir -p /usr/local/bin'
	bash -c 'mkdir -p /usr/local/include'
ifneq ($(shell id -u),0)
	sudo bash -c 'install -v $(PWD)/conf/usr/local/bin/*  /usr/local/bin'
else
	bash -c 'install -v $(PWD)/conf/usr/local/bin/*  /usr/local/bin'
endif
	@echo ''
	#TODO:
	#bash -c '$(GIT_REPO_PATH)/conf/config.bitcoin.conf.sh'
	@echo ''
	bash -c 'install -v $(PWD)/conf/bitcoin.conf    $(STATOSHI_DATA_DIR)/bitcoin.conf'
	bash -c 'install -v $(PWD)/conf/additional.conf $(STATOSHI_DATA_DIR)/additional.conf'
	bash -c 'install -v $(PWD)/docker/docker-compose.yml .'
ifneq ($(shell id -u),0)
	sudo bash -c 'mkdir -p /usr/local/include/'
	sudo bash -c 'install -v $(PWD)/src/statsd_client.h		/usr/local/include/statsd_client.h'
	sudo bash -c 'install -v $(PWD)/src/statsd_client.cpp		/usr/local/include/statsd_client.cpp'
endif
	@echo ''
#######################
.PHONY: build-shell
build-shell:
	@echo ''
	bash -c 'cat ./docker/shell                > shell'
	$(DOCKER_COMPOSE) $(VERBOSE) build $(NOCACHE) shell
	@echo ''
#######################
.PHONY: shell
shell: report build-shell
	@echo 'shell'
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	@echo ''
	$(DOCKER_COMPOSE) --verbose -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh
	@echo ''
else
	# run the command
	@echo ''
	$(DOCKER_COMPOSE) --verbose -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "$(CMD_ARGUMENTS)"
	@echo ''
endif
#######################
.PHONY: build-header
build-header:
	@echo ''
	$(DOCKER_COMPOSE) $(VERBOSE) build $(NOCACHE) header
	@echo ''
#######################
.PHONY: header
header: report build-header
	@echo 'header'
	@echo ''
	$(DOCKER_COMPOSE) $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run header sh -c "cd /home/${HOST_USER} && ls"
	@echo ''
	docker tag $(PROJECT_NAME):header-$(HOST_USER) docker.pkg.github.com/$(GIT_PROFILE)/$(PROJECT_NAME)/header-$(HOST_USER)

.PHONY: signin
signin:
	bash -c 'cat ~/GH_TOKEN.txt | docker login docker.pkg.github.com -u RandyMcMillan --password-stdin'

.PHONY: package-header
package-header:
	touch TIME && echo $(TIME) > TIME && git add -f TIME
	#legit . -m "make package-header at $(TIME)" -p 00000
	git commit --amend --no-edit --allow-empty
	bash -c 'docker tag $(PROJECT_NAME):header-$(HOST_USER) docker.pkg.github.com/$(GIT_PROFILE)/$(PROJECT_NAME)/header-$(HOST_USER):$(TIME)'
	bash -c 'docker push                                    docker.pkg.github.com/$(GIT_PROFILE)/$(PROJECT_NAME)/header-$(HOST_USER):$(TIME)'
	bash -c 'docker tag $(PROJECT_NAME):header-$(HOST_USER) docker.pkg.github.com/$(GIT_PROFILE)/$(PROJECT_NAME)/header-$(HOST_USER)' #defaults to latest
	bash -c 'docker push                                    docker.pkg.github.com/$(GIT_PROFILE)/$(PROJECT_NAME)/header-$(HOST_USER)'

#######################
#.PHONY: shell
#shell: header
#	@echo 'header'
#	@echo ''
#	$(DOCKER_COMPOSE) $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run header sh
#
#######################
.PHONY: build
build: report
	@echo 'build'
	$(DOCKER_COMPOSE) $(VERBOSE) build $(NOCACHE) statoshi
	@echo ''
#######################
.PHONY: run
run: init build
	@echo 'run'
ifeq ($(CMD_ARGUMENTS),)
	@echo ''
	$(DOCKER_COMPOSE) $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run -d --publish $(PUBLIC_PORT):3000 --publish 8125:8125 --publish 8126:8126 --publish 8333:8333 --publish 8332:8332 statoshi sh
	@echo ''
else
	@echo ''
	$(DOCKER_COMPOSE) $(VERBOSE) -p $(PROJECT_NAME)_$(HOST_UID) run -d --publish $(PUBLIC_PORT):3000 --publish 8125:8125 --publish 8126:8126 --publish 8333:8333 --publish 8332:8332 statoshi sh -c "$(CMD_ARGUMENTS)"
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
ifneq ($(shell id -u),0)
	bash -c 'sudo make torproxy user=root &'
endif
ifeq ($(CMD_ARGUMENTS),)
	$(DOCKER_COMPOSE) $(VERBOSE) -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --publish 8118:8118 --publish 9050:9050  --publish 9051:9051 --rm torproxy
else
	$(DOCKER_COMPOSE) $(VERBOSE) -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --publish 8118:8118 --publish 9050:9050  --publish 9051:9051 --rm torproxy sh -c "$(CMD_ARGUMENTS)"
endif
	@echo ''
#######################
.PHONY: clean
clean:
	# remove created images
	@$(DOCKER_COMPOSE) -p $(PROJECT_NAME)_$(HOST_UID) down --remove-orphans --rmi all 2>/dev/null \
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
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME)_$(HOST_UID) down
	docker system prune -af
#######################
.PHONY: prune-network
prune-network:
	@echo 'prune-network'
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME)_$(HOST_UID) down
	docker network prune -f
#######################
.PHONY: statoshi-docs
statoshi-docs:
#$ make report no-cache=true verbose=true cmd='make doc' user=root doc
#SHELL := /bin/bash
	@echo 'statoshi-docs'
	bash -c "if pgrep MacDown; then pkill MacDown; fi"
	bash -c "curl https://raw.githubusercontent.com/jlopp/statoshi/master/README.md -o ./docker/README.md"
	bash -c "cat ./docker/README.md >  README.md"
	bash -c "cat ./docker/DOCKER.md >> README.md"
#	bash -c "echo '<insert string>' >> README.md"
	bash -c "echo '----' >> README.md"
	bash -c "echo '## [$(PROJECT_NAME)]($(GIT_SERVER)/$(GIT_PROFILE)/$(PROJECT_NAME)) [$(GIT_HASH)]($(GIT_SERVER)/$(GIT_PROFILE)/$(PROJECT_NAME)/commit/$(GIT_HASH))' >> README.md"
	bash -c "echo '##### &#36; <code>make</code>' >> README.md"
	bash -c "make help >> README.md"
	bash -c "if hash open 2>/dev/null; then open README.md; fi || echo failed to open README.md"
.PHONY: push
push:
	@echo 'push'
	#bash -c "git reset --soft HEAD~1 || echo failed to add docs..."
	#bash -c "git add README.md docker/README.md docker/DOCKER.md *.md docker/*.md || echo failed to add docs..."
	#bash -c "git commit --amend --no-edit --allow-empty -m '$(GIT_HASH)'          || echo failed to commit --amend --no-edit"
	#bash -c "git commit         --no-edit --allow-empty -m '$(GIT_PREVIOUS_HASH)' || echo failed to commit --amend --no-edit"
	bash -c "git push -f --all git@github.com:$(GIT_PROFILE)/$(PROJECT_NAME).git || echo failed to push docs"
	bash -c "git push -f --all git@github.com:bitcoincore-dev/statoshi.host.git || echo failed to push to statoshi.host"
.PHONY: push-docs
push-docs: statoshi-docs push
	@echo 'push-docs'
#######################
package-statoshi: init
	#@echo "legit . -m "$(HOST_USER):$(TIME)" -p 0000000 && make user=root package && GPF"
	bash -c 'cat ~/GH_TOKEN.txt | docker login docker.pkg.github.com -u RandyMcMillan --password-stdin'
	bash -c 'docker tag $(PROJECT_NAME):$(HOST_USER) docker.pkg.github.com/$(GIT_PROFILE)/$(DOCKERFILE)/$(HOST_USER):$(TIME)'
	bash -c 'docker push                             docker.pkg.github.com/$(GIT_PROFILE)/$(DOCKERFILE)/$(HOST_USER):$(TIME)'
	bash -c 'docker tag $(PROJECT_NAME):$(HOST_USER) docker.pkg.github.com/$(GIT_PROFILE)/$(DOCKERFILE)/$(HOST_USER)'
	bash -c 'docker push                             docker.pkg.github.com/$(GIT_PROFILE)/$(DOCKERFILE)/$(HOST_USER)'
########################
.PHONY: package-all
package-all:

ifeq ($(slim),true)
	make package-all slim=false
endif
	make header package-header build package-statoshi


########################
.PHONY: automate
automate:
	./.github/workflows/automate.sh
-include funcs.mk
-include Makefile

