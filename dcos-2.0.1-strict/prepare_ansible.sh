#!/usr/bin/env bash

cp hosts dcos-ansible/inventory
cp dcos.yml dcos-ansible/group_vars/all/dynamic.yml
cp custom-config.yml dcos-ansible/group_vars/all/custom-config.yml