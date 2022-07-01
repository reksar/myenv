#!/bin/bash
. linux/scripts/ensure-ansible.sh
ansible-playbook --ask-become-pass -i ansible/hosts ansible/config/main.yml
