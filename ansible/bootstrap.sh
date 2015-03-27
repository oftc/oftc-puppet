#!/bin/sh

set -eux

host="$1"

# This assumes the new host is already in /etc/ansible/hosts.
# Alternatively, do this:
# echo $host > hosts
# ansible-playbook -i hosts -l $host bootstrap.yaml

ansible-playbook -l $host bootstrap.yaml
