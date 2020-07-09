ifeq ($(Makefile),)
Makefile := defined
endif

DOCKERFILE=$(notdir $(PWD))
DOCKERFILE_SLIM=stats.build.slim
DOCKERFILE_GUI=stats.build.gui
DOCKERFILE_EXTRACT=stats.build.all.extract

# If you see pwd_unknown showing up, this is why. Re-calibrate your system.
PWD ?= pwd_unknown

# PROJECT_NAME defaults to name of the current directory.
# should not need to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

# Note. If you change this, you also need to update docker-compose.yml.
# Useful in a setting with multiple services/ makefiles.
SERVICE_TARGET := main

# if vars not set specifially: try default to environment, else fixed value.
# strip to ensure spaces are removed in future editorial mistakes.
# tested to work consistently on popular Linux flavors and Mac.
ifeq ($(user),)
# USER retrieved from env, UID from shell.
HOST_USER ?= $(strip $(if $(USER),$(USER),nodummy))
HOST_UID ?= $(strip $(if $(shell id -u),$(shell id -u),4000))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER = $(user)
HOST_UID = $(strip $(if $(uid),$(uid),0))
endif

THIS_FILE := $(lastword $(MAKEFILE_LIST))
CMD_ARGUMENTS ?= $(cmd)

# export such that its passed to shell functions for Docker to pick up.
export PROJECT_NAME
export HOST_USER
export HOST_UID

# all our targets are phony (no files to check).
.PHONY: help shell build-shell rebuild-shell service login concat-all build-all run-all statoshi extract concat-slim build-slim run-slim concat-gui build-gui rebuild-gui run-gui test-gui destroy-all autogen depends configure doc

# suppress make's own output
#.SILENT:

# Regular Makefile part for buildpypi itself
help:
	@echo ''
	@echo ''
	@echo '  Usage:	make -fmk [TARGET] [EXTRA_ARGUMENTS]'
	@echo ''
	@echo '  Targets:'
	@echo ''
	@echo '  	build	    build docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	rebuild	    rebuild docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	test	    test docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	service	    run as service --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	login	    run as service and login --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	clean	    remove docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  	prune	    shortcut for docker system prune -af. Cleanup inactive containers and cache.'
	@echo ''
	@echo '  Shell:	    make -fmk user=$(HOST_USER) shell'
	@echo ''
	@echo '  	shell	    docker image with ~/${PROJECT_NAME}'
	@echo '  	shell	    run docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo ''
	@echo ''
	@echo ''
	@echo ''
	@echo '  Extra:'
	@echo ''
	@echo '  	cmd=:	    make -fmk shell cmd="whoami"'
	@echo '  	-----	    ---------------------------'
	@echo '  	user=	    overrides current user.'
	@echo '  	user=:	    make shell user=root (no need to set uid=0)'
	@echo '  	uid=	    overrides current user uid.'
	@echo '  	uid=:	    make shell user=$(USER) uid=4000 (defaults to 0 if user= set)'
	@echo ''
	@echo ''

shell:
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh
else
	# run the command
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "$(CMD_ARGUMENTS)"
endif

build-shell:
	# only build the container. Note, docker does this also if you apply other targets.
	docker-compose -f docker-compose.yml build shell

rebuild-shell:
	# force a rebuild by passing --no-cache
	docker-compose -f docker-compose.yml build --no-cache shell

service:
	# run as a (background) service
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) up -d shell

login: service
	# run as a service and attach to it
	docker exec -it $(PROJECT_NAME)_$(HOST_UID) sh

########################
concat-all:
	#concat-all
	bash -c '$(pwd) cat header.dockerfile >               $(DOCKERFILE)'
	bash -c '$(pwd) cat statoshi.all.dockerfile >>        $(DOCKERFILE)'
	bash -c '$(pwd) cat footer.dockerfile >>              $(DOCKERFILE)'
#######################
build-all:
	bash -c '$(pwd) make -f mk concat-all'
	docker build -f $(DOCKERFILE) --rm -t $(DOCKERFILE) .
#######################
run-all:
ifeq ($(Makefile),)
		Makefile := defined
		bash -c '$(pwd) make clean'
endif
#	bash -c '$(pwd) make -f mk build-all'
#		#docker run --restart always --name $(DOCKERFILE) -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE) .
#		docker run --restart always -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE) .
#	bash -c '$(pwd) make -fmk user=root build-gui'
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish  3000:3000 --publish 8080:8080 --publish 8125:8125 --publish 8126:8126 --rm statoshi sh
else
	# run-all with command
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 3000:3000 --publish 8080:8080 --publish 8125:8125 --publish 8126:8126 --rm statoshi sh -c "$(CMD_ARGUMENTS)"
endif

#######################
extract:
	#extract TODO CREATE PACKAGE for distribution
	bash -c '$(pwd) make -fmk build-all'
	sed '$d' $(DOCKERFILE) | sed '$d' | sed '$d' > $(DOCKERFILE_EXTRACT)
		docker build -f $(DOCKERFILE_EXTRACT) --rm -t $(DOCKERFILE_EXTRACT) .
		docker run --name $(DOCKERFILE_EXTRACT) $(DOCKERFILE_EXTRACT) /bin/true
		#docker cp $(DOCKERFILE_EXTRACT):/usr/local/bin/bitcoind        $(pwd)/conf/usr/local/bin/bitcoind
		#docker cp $(DOCKERFILE_EXTRACT):/usr/local/bin/bitcoin-cli     $(pwd)/conf/usr/local/bin/bitcoin-cli
		#docker cp $(DOCKERFILE_EXTRACT):/usr/local/bin/bitcoin-tx      $(pwd)/conf/usr/local/bin/bitcoin-tx
		docker rm $(DOCKERFILE_EXTRACT)
		rm -f  $(DOCKERFILE_EXTRACT)'
#######################
concat-slim:
	bash -c '$(pwd) cat header.dockerfile >               $(DOCKERFILE_SLIM)'
	bash -c '$(pwd) cat statoshi.build.slim.dockerfile >> $(DOCKERFILE_SLIM)'
	bash -c '$(pwd) cat footer.dockerfile >>              $(DOCKERFILE_SLIM)'
#######################
build-slim:
	bash -c '$(pwd) make -f mk concat-slim'
	docker build -f $(DOCKERFILE_SLIM) --rm -t $(DOCKERFILE_SLIM) .
#######################
run-slim:
	bash -c '$(pwd) make -f mk slim'
		docker run --restart always --name $(DOCKERFILE_SLIM) -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE_SLIM) .
#######################
concat-gui:
	bash -c '$(pwd) cat header.slim.dockerfile >          $(DOCKERFILE_GUI).dockerfile'
	bash -c '$(pwd) cat stats.gui.dockerfile   >>         $(DOCKERFILE_GUI).dockerfile'
	bash -c '$(pwd) cat footer.dockerfile      >>         $(DOCKERFILE_GUI).dockerfile'
#######################
build-gui:
	bash -c '$(pwd) make -fmk user=root concat-gui'
	docker-compose -f docker-compose.yml build gui
#######################
rebuild-gui:
	bash -c '$(pwd) make -fmk user=root concat-gui'
	# force a rebuild by passing --no-cache
	docker-compose -f docker-compose.yml build --no-cache gui
#######################
run-gui:
	bash -c '$(pwd) make -fmk user=root build-gui'
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 80:3000 --rm gui sh
else
	# run-gui with command
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run  --publish 80:3000 --rm gui sh -c "$(CMD_ARGUMENTS)"
endif
#######################
test-gui:
	# here it is useful to add your own customised tests
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --publish 3333:3000 --rm gui sh -c '\
		echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success
#######################
autogen:
	# here it is useful to add your own customised tests
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c "cd /home/root/stats.bitcoincore.dev  && ./autogen.sh && exit"
#######################
depends:
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "apk add coreutils && exit"
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "make -j $(nproc) download -C /home/root/stats.bitcoincore.dev/depends && exit"
#######################
configure:
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c "cd /home/root/stats.bitcoincore.dev  && ./configure --disable-wallet --disable-tests --disable-hardening --disable-man --enable-util-cli --enable-util-tx --with-gui=no --without-miniupnpc --disable-bench && exit"
#######################
test:
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm shell sh -c '\
		echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success
#######################
clean:
	@docker-compose -p $(PROJECT_NAME)_$(HOST_UID) down --remove-orphans --rmi all 2>/dev/null \
	&& echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" removed.' \
	|| echo 'Image(s) for "$(PROJECT_NAME):$(HOST_USER)" already removed.'
	bash -c 'touch stats.build.slim.dockerfile stats.build.gui.dockerfile stats.build.all.extract.dockerfile'
	bash -c '[ -f $(DOCKERFILE_SLIM).dockerfile ]    && rm -f $(DOCKERFILE_SLIM).dockerfile'
	bash -c '[ -f $(DOCKERFILE_GUI).dockerfile ]     && rm -f $(DOCKERFILE_GUI).dockerfile'
	bash -c '[ -f $(DOCKERFILE_EXTRACT).dockerfile ] && rm -f $(DOCKERFILE_EXTRACT).dockerfile'
#######################
prune::
	#prune
	docker system prune -af
#######################
destroy-all:
	docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)
#######################
doc:

	export HOST_USER=root
	export HOST_UID=0

	bash -c '$(pwd) make -fmk user=root'
	bash -c 'cat README > README.md && cat Docker.md >> README.md'
#######################

