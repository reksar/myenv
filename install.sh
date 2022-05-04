#!/bin/bash
ansible-playbook --ask-become-pass -i ansible/hosts ansible/install/$1.yml
