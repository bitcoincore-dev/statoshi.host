ifeq ($(Makefile),)
Makefile := defined
endif


DOCKERFILE=stats.bitcoincore.dev
DOCKERFILE_SLIM=stats.build.slim
DOCKERFILE_GUI=stats.build.gui
DOCKERFILE_EXTRACT=stats.build.all.extract

# If you see pwd_unknown showing up, this is why. Re-calibrate your system.
PWD ?= pwd_unknown

# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

# Note. If you change this, you also need to update docker-compose.yml.
# only useful in a setting with multiple services/ makefiles.
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
.PHONY: shell help build rebuild service login test clean prune concat-all concat-slim slim build-all extract run-all run-slim run-gui build-gui concat-gui test-gui destroy-all autogen depends configure

# suppress makes own output
#.SILENT:

# Regular Makefile part for buildpypi itself
help:
	@echo ''
	@echo ''
	@echo '    Usage:	make -fmk [TARGET] [EXTRA_ARGUMENTS]'
	@echo ''
	@echo '  Targets:'
	@echo ''
	@echo '    build	build docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  rebuild	rebuild docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '     test	test docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  service	run as service --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '    login	run as service and login --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '    clean	remove docker --image-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo '    prune	shortcut for docker system prune -af. Cleanup inactive containers and cache.'
	@echo ''
	@echo '    Shell:'
	@echo ''
	@echo '    shell	run docker --container-- for current user: $(HOST_USER)(uid=$(HOST_UID))'
	@echo ''
	@echo ''
	@echo ''
	@echo ''
	@echo '    Extra:'
	@echo ''
	@echo '     cmd=:	make -fmk shell cmd="whoami"'
	@echo ''
	@echo '    user=	overrides current user. Might require additional privileges.'
	@echo '    user=:	make shell user=root (no need to set uid=0)'
	@echo '     uid=	overrides current user uid.'
	@echo '     uid=:	make shell user=$(USER) uid=4000 (defaults to 0 if user= set)'
	@echo ''
	@echo ''

shell:
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh
else
	# run the command
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c "$(CMD_ARGUMENTS)"
endif

rebuild:
	# force a rebuild by passing --no-cache
	docker-compose -f shell.yml build --no-cache $(SERVICE_TARGET)

service:
	# run as a (background) service
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) up -d $(SERVICE_TARGET)

login: service
	# run as a service and attach to it
	docker exec -it $(PROJECT_NAME)_$(HOST_UID) sh

build:
	# only build the container. Note, docker does this also if you apply other targets.
	docker-compose -f shell.yml build $(SERVICE_TARGET)

########################


concat-all:
	#concat-all
	bash -c '$(pwd) cat header.dockerfile >               $(DOCKERFILE)'
	bash -c '$(pwd) cat statoshi.build.all.dockerfile >>  $(DOCKERFILE)'
	bash -c '$(pwd) cat footer.dockerfile >>              $(DOCKERFILE)'


#######################


build-all:
	#build-all
	bash -c '$(pwd) make -f mk concat-all'
	docker build -f $(DOCKERFILE) --rm -t $(DOCKERFILE) .


#######################


run-all:
	#run-all
ifeq ($(Makefile),)
		Makefile := defined
		bash -c '$(pwd) make clean'
endif

	bash -c '$(pwd) make -f mk concat-all'
	bash -c '$(pwd) make -f mk build-all'
		#docker run --restart always --name $(DOCKERFILE) -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE) .
		docker run --restart always -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 80:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE) .


#######################


concat-slim:
	#concat-slim
	bash -c '$(pwd) cat header.dockerfile >               $(DOCKERFILE_SLIM)'
	bash -c '$(pwd) cat statoshi.build.slim.dockerfile >> $(DOCKERFILE_SLIM)'
	bash -c '$(pwd) cat footer.dockerfile >>              $(DOCKERFILE_SLIM)'


#######################


slim:
	#slim
	bash -c '$(pwd) make -f mk concat-slim'
	docker build -f $(DOCKERFILE_SLIM) --rm -t $(DOCKERFILE_SLIM) .


#######################


run-slim:
	#run-slim
	bash -c '$(pwd) make -f mk slim'
		docker run --restart always --name $(DOCKERFILE_SLIM) -e GF_AUTH_ANONYMOUS_ENABLED=true -it -p 3000:3000 -p 8080:8080 -p 8125:8125 -p 8126:8126 $(DOCKERFILE_SLIM) .


#######################


extract:
	#extract
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


concat-gui:
	#concat-gui
	bash -c '$(pwd) cat header.slim.dockerfile >          $(DOCKERFILE_GUI).dockerfile'
	bash -c '$(pwd) cat stats.gui.dockerfile >>           $(DOCKERFILE_GUI).dockerfile'
	bash -c '$(pwd) cat footer.dockerfile >>              $(DOCKERFILE_GUI).dockerfile'


#######################


build-gui:
#rebuild-gui
	bash -c '$(pwd) make -fmk user=root concat-gui'
	# force a rebuild by passing --no-cache
	docker-compose -f docker-compose.yml build --no-cache gui


#######################


run-gui:
	# run-gui no command
	bash -c '$(pwd) make -fmk user=root build-gui'
ifeq ($(CMD_ARGUMENTS),)
	# no command is given, default to shell
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --restart always --publish 80:3000 --rm gui sh
else
	# run-gui with command
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --restart always --publish 80:3000 --rm gui sh -c "$(CMD_ARGUMENTS)"
endif


#######################


test-gui:
	#test-gui
	# here it is useful to add your own customised tests
	docker-compose -f docker-compose.yml -p $(PROJECT_NAME)_$(HOST_UID) run --publish 3333:3000 --rm gui sh -c '\
		echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success


#######################
autogen:
	#test
	# here it is useful to add your own customised tests
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c "cd /home/root/stats.bitcoincore.dev  && ./autogen.sh && exit"


#######################


depends:
	#depends
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c "apk add coreutils && exit"
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c "make -j $(nproc) download -C /home/root/stats.bitcoincore.dev/depends && exit"


#######################


configure:
	#configure
	# here it is useful to add your own customised tests
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c "cd /home/root/stats.bitcoincore.dev  && ./configure --disable-wallet --disable-tests --disable-hardening --disable-man --enable-util-cli --enable-util-tx --with-gui=no --without-miniupnpc --disable-bench && exit"


#######################


test:
	#test
	# here it is useful to add your own customised tests
	docker-compose -f shell.yml -p $(PROJECT_NAME)_$(HOST_UID) run --rm $(SERVICE_TARGET) sh -c '\
		echo "I am `whoami`. My uid is `id -u`." && echo "Docker runs!"' \
	&& echo success


#######################


clean:
	# remove created images and dockerfiles
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
	bash -c '$(pwd) make -fmk clean'
	bash -c '$(pwd) make -fmk prune'
	docker ps -aq && docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)


#######################

