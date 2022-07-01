#!/bin/bash

# Ansible creates *.retry files when something goes wrong.
find ./ansible/ -type f -name '*.retry' -delete

rm -rf venv
