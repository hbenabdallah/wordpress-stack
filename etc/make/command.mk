## @Application Display application version
version:
	@cat VERSION
	@printf "\n"

## @Application Start application
start: start-proxy start-services docker-network docker-start
	@printf " - Successful ${GREEN}start application${RESET} project\n"
	@printf " - Welcome !! The project is available on this url: ${YELLOW}${PROJECT_URL}${RESET}\n"

## @Application Stop application
stop: docker-stop
	@printf " - Successful ${GREEN}stopping${RESET} of the application\n"

## @Application Start nginx and dns proxy application
start-proxy:
ifneq ("$(wildcard bin/docker-compose)","")
	@$(NGINX_PROXY)
	@$(DNS_PROXY)
endif

## @Application Start common stack services of application
start-services:
ifneq ("$(wildcard bin/docker-compose)","")
	@$(COMMON_SERVICE)
endif

## @Application Access the command line interface of main application
cli:
	@docker exec -ti "$(shell docker ps -qf "name=app_${PROJECT_NAME}")" bash -c "$(ARG)"

## @Install Install application to <env> environment (Default <env> = dev)
install: build-env docker-pull start-proxy install-npm build-newman install-deps install-hooks docker-network install-hosts
	$(shell echo "Application installed!" >> .install)
	@printf " - Welcome !! now execute ${GREEN}make start${RESET} to launch all services in the project.\n"

## @Build Build project role (directory,file,...etc)
build-role:
	$(shell chmod 776 var/logs var/cache)

## @Install Install hosts and apply permission rules on directory project
install-hosts:
	@printf " - Apply permission rules on directory ${GREEN}logs${RESET} and ${GREEN}cache${RESET}\n"
	@bin/docker-compose run --rm hosts bash -c "grep -q -F '127.0.0.1 ${VIRTUAL_HOST}' $(HOSTS_ETC)/hosts || echo '127.0.0.1 ${VIRTUAL_HOST}' >> ${HOSTS_ETC}/hosts"

## @Install Install npm dependencies project <env> environment (Default <env> = dev)
install-npm:
	@printf " - Installing ${GREEN}npm${RESET} dependencies\n"
	@bin/node bash -c "cd etc/node/ && npm prune && npm install"

## @Install Install php dependencies project <env> environment (Default <env> = dev)
install-deps:
	@printf " - Installing ${GREEN}php${RESET} ${ENV}-dependencies\n"
ifeq ($(ENV), dev)
	@bin/composer update --optimize-autoloader --prefer-dist
else
	@bin/composer update --no-dev --optimize-autoloader --prefer-dist
endif

## @Install Install git and hooks configuration
install-hooks:
	@printf " - Install ${GREEN}git${RESET} hooks\n"
	$(shell mkdir -p ${PWD}/.git/hooks)
	$(shell cp ${PWD}/etc/git/pre-commit ${PWD}/.git/hooks)
	$(shell cp ${PWD}/etc/git/commit-msg ${PWD}/.git/hooks)
	$(shell cp ${HOME}/.gitconfig ${PWD}/.gitconfig)
	$(shell chmod +x ${PWD}/.git/hooks/pre-commit)

## @Install Delete all temporary file and directory
uninstall:
	@printf " - Removing ${GREEN}temporary file and directory${RESET} \n"
	@rm -f etc/node/package-lock.json > /dev/null 2>&1
	@rm -rf etc/node/node_modules > /dev/null 2>&1
	@rm -rf vendor > /dev/null 2>&1
	@rm -f .env > /dev/null 2>&1
	@rm -f .install > /dev/null 2>&1
	@printf " - Successful ${GREEN}clean${RESET} project\n"

## @Install Update all dependencies application to <env>\n environment (Default <env> = dev)
update: stop uninstall
	@rm -f composer.lock > /dev/null 2>&1
	$(MAKE) install

## @Build Build newman configuration
build-newman:
	@printf " - Build ${GREEN}newman${RESET} config\n"
	@sed -e "s@{APP_HOST_NAME}@$(PROJECT_URL)@g" -e "s@{ACCESS_TOKEN}@$(ACCESS_TOKEN)@g" < tests/functionals/bootstrap/newman.json.dist > ${PWD}/newman.json

## @Build Build environment configuration
build-env:
	@printf " - Build ${GREEN}.env${RESET} \n"
	$(shell cat ${PWD}/etc/.env.dist > .env)
	$(shell echo "UID=$(UID)" >> .env)
	$(shell echo "GID=$(GID)" >> .env)
	$(shell echo "USER_NAME=$(USER_NAME)" >> .env)
	$(shell echo "PATH=$(PATH)" >> .env)
	$(shell echo "PWD=$(PWD)" >> .env)
	$(shell echo "NETWORK=$(DOCKER_NETWORK)" >> .env)
	$(shell echo "COMPOSER_CACHE=$(COMPOSER_CACHE)" >> .env)
	$(shell echo "NPM_CACHE=$(NPM_CACHE)" >> .env)

## @Tests Execute unit tests application
tests-unit:
	@printf " - Execute unit tests application${RESET}\n"
	@bin/phpunit --colors=always --bootstrap vendor/autoload.php --testdox tests

## @Tests Execute functionals tests application, if you want to run a specific feature or profile add FUNC_FEATURE=<feature name> and/or add FUNC_PROFILE=<firefox>
tests-func:
	@printf " - Execute functional tests application${RESET}\n"
	@bin/docker-compose -f etc/docker/newman/docker-compose.yaml run --rm newman run collection.json -e newman.json -r cli,json --reporter-json-export="/etc/newman/tests/functionals/build/results.json"
	@bin/docker-compose -f etc/docker/newman/docker-compose.yaml down
	@printf "${GREEN}Functional tests ended with success${RESET}\n"

## @Docker Start all container dockers to run application
docker-start:
	@bin/docker-compose up -d app

## @Docker Stop all running containers in the application
docker-stop:
	@bin/docker-compose down
	#@docker system prune -f

## @Docker Build the image of the application
docker-build:
	@bin/docker-compose build --force-rm app

## @Docker Pull all docker images
docker-pull:
	@bin/docker-compose pull --ignore-pull-failures

## @Docker Display status of all docker container as running
docker-status:
	@bin/docker-compose ps

## @Docker Display logs of all docker container as running
docker-logs:
	@bin/docker-compose logs -f

## @Docker Access the command line interface of container name
docker-main:
	@docker exec -ti "$(shell docker ps -qf "name=app_${PROJECT_NAME}" )" bash

## @Docker Access the command line interface of container name
docker-mysql:
	@docker exec -ti "$(shell docker ps -qf "name=sql_${PROJECT_NAME}" )" bash

## @Docker Create default network
docker-network:
	@docker network inspect $(DOCKER_NETWORK)_default >/dev/null || docker network create $(DOCKER_NETWORK)_default

## @Generate Generate SSL Certification
gen-certs:
	@bin/docker-compose run --rm gen-certs

## @Check Check git command
check-git:
	@bin/grumphp run --testsuite=check-git

## @Check Check yaml command
check-yaml:
	@bin/grumphp run --testsuite=check-yaml

## @Check Check security command
check-security:
	@bin/grumphp run --testsuite=check-security

## @Check Check make command
check-make:
	@bin/grumphp run --testsuite=check-make

## @Check Check php command
check-php:
	@bin/grumphp run --testsuite=check-php

## @Check check php version v=7.4 command
check-php-version:
	@bin/grumphp run --testsuite=check-php-version

## @Check Check php cpd command
check-php-cpd:
	@bin/grumphp run --testsuite=check-php-cpd

## @Check Check php cs command
check-php-cs:
	@bin/grumphp run --testsuite=check-php-cs

## @Check Check php cs fix command
check-php-cs-fix:
	@bin/php php ./vendor/bin/php-cs-fixer fix src --rules=@Symfony,-@PSR1,-@PSR2,-blank_line_before_statement

## @Git Check pre commit
git-pre-commit:
	@bin/grumphp 'git:pre-commit' '--skip-success-output'

## @Git Check commit message
git-commit-msg:
	@bin/grumphp 'git:commit-msg' $(filter-out $@,$(MAKECMDGOALS))
