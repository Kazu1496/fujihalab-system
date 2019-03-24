#!/usr/bin/env bash

set -eu

function pb() {
    ansible-playbook \
    --user=ec2-user \
    -i inventory/hosts \
    playbooks/$1
}

