ifneq ($(Makefile),)
	Makefile := defined
endif

DOCKERFILE=$(notdir $(PWD))
DOCKERFILE_SLIM=stats.build.slim
DOCKERFILE_GUI=stats.build.gui
DOCKERFILE_EXTRACT=stats.build.all.extract

# If you see pwd_unknown showing up, this is why. Re-calibrate your system.
PWD ?= pwd_unknown

# Note the different service configs in  docker-compose.yml.
# We override this default for different build/run configs
SERVICE_TARGET := main

ifeq ($(user),)
# USER retrieved from env, UID from shell.
HOST_USER = root
HOST_UID  = 0
#HOST_USER ?= $(strip $(if $(USER),$(USER),nodummy))
#HOST_UID  ?=  $(strip $(if $(shell id -u),$(shell id -u),4000))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER = root
HOST_UID  = 0
#HOST_USER = $(user)
#HOST_UID = $(strip $(if $(uid),$(uid),0))
endif
# PROJECT_NAME defaults to name of the current directory.
# should not need to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

THIS_FILE := $(lastword $(MAKEFILE_LIST))
CMD_ARGUMENTS ?= $(cmd)

# export such that its passed to shell functions for Docker to pick up.
# control alpine version from here
BASE_IMAGE = alpine
BASE_VERSION = 3.11.6

export BASE_IMAGE
export BASE_VERSIOn
export PROJECT_NAME
export HOST_USER
export HOST_UID

# all our targets are phony (no files to check).
.PHONY: help shell build-shell rebuild-shell service login concat-all build-all run-all make-statoshi run-statoshi extract concat-slim build-slim run-slim concat-gui build-gui rebuild-gui run-gui test-gui destroy-all autogen depends config doc link

# suppress make's own output
#.SILENT:

help:
	@echo ''
	@echo '	Bitcoin:'
	@echo ''
	@echo '  	            ./autogen'
	@echo '  	            ./configure --disable-wallet #et cetera...'
	@echo '  	            make -f Makefile'
	@echo ''
	@echo ''
	@echo '	Docker:	    make [TARGET] [EXTRA_ARGUMENTS]'
	@echo ''
	@echo '	Shell:	    alpine dev environment'
	@echo ''
	@echo '  	shell	    make user=$(HOST_USER) shell'
	@echo ''
	@echo '	Targets:'
	@echo ''
	@echo '  	build	    build docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	rebuild	    rebuild docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	test	    test docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	service	    run as service --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	login	    run as service and login --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	clean	    remove docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	prune	    shortcut for docker system prune -af. Cleanup inactive containers and cache.'
	@echo ''
	@echo ''
	@echo ''
	@echo ''
	@echo '	Extra:'
	@echo ''
	@echo '  	cmd=:	    make shell cmd="whoami"'
	@echo ''
	@echo ''
#######################
link:
	@echo ''
	bash -c 'ln -sf ./docker/shell                   .'
	bash -c 'ln -sf ./docker/docker-compose.yml      .'
	bash -c 'ln -sf ./docker/statoshi                .'
	bash -c 'ln -sf ./docker/gui                     .'
	bash -c 'ln -sf ./docker/$(DOCKERFILE)   .'
	bash -c 'ln -sf ./docker/$(DOCKERFILE_SLIM)        .'
	bash -c 'ln -sf ./docker/$(DOCKERFILE_GUI)         .'
	bash -c 'ln -sf ./docker/$(DOCKERFILE_EXTRACT) .'
	@echo ''
#######################
build-shell: link
	docker-compose build shell
#######################
rebuild-shell: link
	docker-compose build --no-cache shell
#######################
shell: build-shell
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh
else
	# run the command
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "$(CMD_ARGUMENTS)"
endif
#######################
autogen: link
	# here it is useful to add your own customised tests
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh -c "cd /home/root/stats.bitcoincore.dev  && ./autogen.sh && exit"
#######################
config: autogen
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh -c "cd /home/root/stats.bitcoincore.dev  && ./configure --disable-wallet --disable-tests --disable-hardening --disable-man --enable-util-cli --enable-util-tx --with-gui=no --without-miniupnpc --disable-bench && exit"
#######################
depends: config
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh -c "apk add coreutils && exit"
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh -c "make -j $(nproc) download -C /home/root/stats.bitcoincore.dev/depends && exit"
#######################
test:
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c '\
	echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success
#######################
make-statoshi: depends
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh -c "cd /home/root/stats.bitcoincore.dev && make install && exit"
#######################
run-statoshi: make-statoshi
	docker-compose build statoshi
ifeq ($(CMD_ARGUMENTS),)
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh
else
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh -c "$(CMD_ARGUMENTS)"
endif
#######################
service:
	# run as a (background) service
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) up -d shell
#######################
login: service
	# run as a service and attach to it
	docker exec -it $(PROJECT_NAME)_$(HOST_UID) sh
########################
concat-all:
	#concat-all
	bash -c '$(pwd) cat ./docker/header >               $(DOCKERFILE)'
	bash -c '$(pwd) cat ./docker/statoshi.all >>        $(DOCKERFILE)'
	bash -c '$(pwd) cat ./docker/footer >>              $(DOCKERFILE)'
	bash -c 'echo created...                            $(DOCKERFILE)'
#######################
build-all: concat-all
	#bash -c '$(pwd) make concat-all'
	docker build -f $(DOCKERFILE) --rm -t $(DOCKERFILE) .
#######################
run-all: build-all
ifeq ($(CMD_ARGUMENTS),)
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish  3000:3000 --publish 8080:8080 --publish 8125:8125 --publish 8126:8126 --rm statoshi sh
else
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 3000:3000 --publish 8080:8080 --publish 8125:8125 --publish 8126:8126 --rm statoshi sh -c "$(CMD_ARGUMENTS)"
endif
#######################
extract: link
	#extract TODO CREATE PACKAGE for distribution
	#bash -c '$(pwd) make build-all'
	sed '$d' $(DOCKERFILE) | sed '$d' | sed '$d' > $(DOCKERFILE_EXTRACT)
	docker build -f $(DOCKERFILE_EXTRACT) --rm -t $(DOCKERFILE_EXTRACT) .
	docker run --name $(DOCKERFILE_EXTRACT) $(DOCKERFILE_EXTRACT) /bin/true
	#docker cp $(DOCKERFILE_EXTRACT):/usr/local/bin/bitcoind        $(pwd)/conf/usr/local/bin/bitcoind
	#docker cp $(DOCKERFILE_EXTRACT):/usr/local/bin/bitcoin-cli     $(pwd)/conf/usr/local/bin/bitcoin-cli
	#docker cp $(DOCKERFILE_EXTRACT):/usr/local/bin/bitcoin-tx      $(pwd)/conf/usr/local/bin/bitcoin-tx
	docker rm $(DOCKERFILE_EXTRACT)
	rm -f  $(DOCKERFILE_EXTRACT)
#######################
concat-slim: link
	bash -c '$(pwd) cat ./docker/header.dockerfile >               $(DOCKERFILE_SLIM)'
	bash -c '$(pwd) cat ./docker/statoshi.build.slim.dockerfile >> $(DOCKERFILE_SLIM)'
	bash -c '$(pwd) cat ./docker/footer.dockerfile >>              $(DOCKERFILE_SLIM)'
#######################
build-slim: concat-slim
	#bash -c '$(pwd) make concat-slim'
	docker build -f $(DOCKERFILE_SLIM) --rm -t $(DOCKERFILE_SLIM) .
#######################
run-slim: build-slim
	#bash -c '$(pwd) make slim'
		docker run --restart always --name $(DOCKERFILE_SLIM) -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE_SLIM) .
#######################
concat-gui:
	@echo ''
	bash -c 'cat    ./docker/header.slim              > $(DOCKERFILE_GUI)'
	bash -c 'cat    ./docker/gui                     >> $(DOCKERFILE_GUI)'
	bash -c 'cat    ./docker/footer                  >> $(DOCKERFILE_GUI)'
	@echo ''
#######################
build-gui: concat-gui link
	docker-compose -f docker-compose.yml build gui
	@echo ''
#######################
rebuild-gui:
	bash -c '$(pwd) make user=root concat-gui'
	docker-compose -f docker-compose.yml build --no-cache gui
	@echo ''
#######################
run-gui: build-gui
ifeq ($(CMD_ARGUMENTS),)
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 80:3000 --rm gui sh
	@echo ''
else
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 80:3000 --rm gui sh -c "$(CMD_ARGUMENTS)"
	@echo ''
endif
#######################
test-gui: build-gui
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --publish 3333:3000 --rm gui sh -c '\
		echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success
#######################
clean:
	@docker-compose -p $(PROJECT_NAME)_$(HOST_UID) down --remove-orphans --rmi all 2>/dev/null \
	&& echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" removed.' \
	|| echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" already removed.'
	bash -c 'rm -f ./shell'
	bash -c 'rm -f ./docker-compose.yml'
	bash -c 'rm -f ./statoshi'
	#bash -c '[ -f $(DOCKERFILE) ]         && rm -f $(DOCKERFILE)'
	#bash -c '[ -f $(DOCKERFILE_SLIM) ]    && rm -f $(DOCKERFILE_SLIM)'
	#bash -c '[ -f $(DOCKERFILE_GUI) ]     && rm -f $(DOCKERFILE_GUI)'
	#bash -c '[ -f $(DOCKERFILE_EXTRACT) ] && rm -f $(DOCKERFILE_EXTRACT)'
#######################
prune:
	docker system prune -af
#######################
destroy-all:
	docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)
#######################
doc:
	export HOST_USER=root
	export HOST_UID=0
	bash -c '$(pwd) make user=root'
	bash -c 'cat README > README.md && cat Docker.md >> README.md'
#######################
-include Makefile

