ifeq ($(Makefile),)
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
HOST_UID = 0
#HOST_USER ?= $(strip $(if $(USER),$(USER),nodummy))
#HOST_UID  ?=  $(strip $(if $(shell id -u),$(shell id -u),4000))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER = root
HOST_UID = 0
#HOST_USER = $(user)
#HOST_UID = $(strip $(if $(uid),$(uid),0))
endif
# PROJECT_NAME defaults to name of the current directory.
# should not need to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

THIS_FILE := $(lastword $(MAKEFILE_LIST))
CMD_ARGUMENTS ?= $(cmd)

# export such that its passed to shell functions for Docker to pick up.
export PROJECT_NAME
export HOST_USER
export HOST_UID

# all our targets are phony (no files to check).
.PHONY: help shell build-shell rebuild-shell service login concat-all build-all run-all statoshi extract concat-slim build-slim run-slim concat-gui build-gui rebuild-gui run-gui test-gui destroy-all autogen depends config doc link statoshi

# suppress make's own output
.SILENT:

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
	@echo '	Shell:	    make shell'
	@echo ''
	@echo '  	shell	    docker image ${PROJECT_NAME}'
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

link:
	bash -c 'ln -sf ./docker/shell .'
	bash -c 'ln -sf ./docker/docker-compose.yml .'
	bash -c 'ln -sf ./docker/statoshi .'

build-shell: link
		docker-compose build shell

rebuild-shell: link
	docker-compose build --no-cache shell

shell: build-shell
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh
else
	# run the command
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "$(CMD_ARGUMENTS)"
endif
build-statoshi: link
		docker-compose build statoshi
statoshi: build-statoshi
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh
else
	# run the command
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) run --rm statoshi sh -c "$(CMD_ARGUMENTS)"
endif
service:
	# run as a (background) service
	docker-compose -p $(PROJECT_NAME)_$(HOST_UID) up -d shell

login: service
	# run as a service and attach to it
	docker exec -it $(PROJECT_NAME)_$(HOST_UID) sh

########################
concat-all:
	#concat-all
	bash -c '$(pwd) cat ./docker/header.dockerfile >               $(DOCKERFILE)'
	bash -c '$(pwd) cat ./docker/statoshi.all.dockerfile >>        $(DOCKERFILE)'
	bash -c '$(pwd) cat ./docker/footer.dockerfile >>              $(DOCKERFILE)'
	bash -c 'echo created...                                       $(DOCKERFILE)'

#######################
build-all: concat-all
	#bash -c '$(pwd) make concat-all'
	docker build -f $(DOCKERFILE) --rm -t $(DOCKERFILE) .
#######################
run-all: build-all
ifeq ($(Makefile),)
		bash -c 'echo run-all'
endif
#	bash -c '$(pwd) make build-all'
#		#docker run --restart always --name $(DOCKERFILE) -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE) .
#		docker run --restart always -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE) .
#	bash -c '$(pwd) make user=root build-gui'
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish  3000:3000 --publish 8080:8080 --publish 8125:8125 --publish 8126:8126 --rm statoshi sh
else
	# run-all with command
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 3000:3000 --publish 8080:8080 --publish 8125:8125 --publish 8126:8126 --rm statoshi sh -c "$(CMD_ARGUMENTS)"
endif

#######################
extract:
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
concat-slim:
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
	bash -c '$(pwd) cat header.slim.dockerfile >          $(DOCKERFILE_GUI)'
	bash -c '$(pwd) cat stats.gui.dockerfile   >>         $(DOCKERFILE_GUI)'
	bash -c '$(pwd) cat footer.dockerfile      >>         $(DOCKERFILE_GUI)'
#######################
build-gui: concat-gui
	#bash -c '$(pwd) make user=root concat-gui'
	docker-compose -f /docker/docker-compose.yml build gui
#######################
rebuild-gui:
	bash -c '$(pwd) make user=root concat-gui'
	# force a rebuild by passing --no-cache
	docker-compose -f /docker/docker-compose.yml build --no-cache gui
#######################
run-gui: build-gui
	#bash -c '$(pwd) make user=root build-gui'
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 80:3000 --rm gui sh
else
	# run-gui with command
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 80:3000 --rm gui sh -c "$(CMD_ARGUMENTS)"
endif
#######################
test-gui: build-gui
	# here it is useful to add your own customised tests
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --publish 3333:3000 --rm gui sh -c '\
		echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success
#######################
autogen:
	# here it is useful to add your own customised tests
	docker-compose -f /docker/shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c "cd /home/root/stats.bitcoincore.dev  && ./autogen.sh && exit"
#######################
depends:
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "apk add coreutils && exit"
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "make -j $(nproc) download -C /home/root/stats.bitcoincore.dev/depends && exit"
#######################
config:
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "cd /home/root/stats.bitcoincore.dev  && ./configure --disable-wallet --disable-tests --disable-hardening --disable-man --enable-util-cli --enable-util-tx --with-gui=no --without-miniupnpc --disable-bench && exit"
#######################
test:
	docker-compose -f /docker/docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c '\
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
	#prune
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

