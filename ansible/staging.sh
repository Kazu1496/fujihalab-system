#!/usr/bin/env bash

HOSTS=inventory/hosts

. ./functions.sh

pbs 01-init-server.yml
pbs 02-install_mysql.yml
pbs 03-install_nodejs.yml
pbs 04-setup_ruby.yml
pbs 05-gitconfig.yml
pbs 06-setup-app.yml
pbs 07-nginx-setup.yml
pbs 08-hogehoge.yml

# mysqlと接続したりnginx起動したりするansibleは後で書く！
