#!/bin/bash

# Source this script when you need to operate with Ansible.


ensure_python3() {
  # TODO
  echo Expecting that Python3 is OK
}


ensure_venv() {
  ensure_python3

  if [ -z $VIRTUAL_ENV ]
  then
    echo Python venv is not active.

    if [[ ! -d venv ]]
    then
      echo Creating Python venv.
      python -m venv venv
    fi

    echo Activating Python venv.
    . venv/bin/activate
  fi

  if [ -z $VIRTUAL_ENV ]
  then
    echo [ERR] Activating venv failed.
    exit 1
  fi
}


install_ansible() {
  pip install --upgrade pip

  # Latest Cryptography version that can be installed without Rust.
  # TODO: ensure `pyconfig.h` (python3-dev package).
  export CRYPTOGRAPHY_DONT_BUILD_RUST=1
  pip install cryptography==3.4.8

  # This Ansible version depends on any Cryptography version.
  pip install ansible==4.10.0
}


ensure_ansible() {

  if [[ ! `which ansible` ]]
  then
    echo Ensuring Ansible with Python venv.
    ensure_venv

    if [[ ! `which ansible` ]]
    then
      echo Installing Ansible into Python venv.
      install_ansible

      if [[ ! `which ansible` ]]
      then
        echo [ERR] Ansible installation failed.
        exit 2
      fi
    fi
  fi
}


ensure_ansible
