#!/usr/bin/env bash

HOSTS=inventory/hosts

. ./functions.sh

# pb 01-init-server.yml
# pb 02-install_mysql.yml
pb 03-install_nodejs.yml
# pb 04-setup_ruby.yml
# pb 05-gitconfig.yml
# pb 06-setup-app.yml
# pb 07-nginx-setup.yml
# pb 08-db_setting_and_create.yml

# mysqlと接続したりnginx起動したりするansibleは後で書く！
