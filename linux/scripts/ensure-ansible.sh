#!/bin/bash

# Source this script before invoking the Ansible.
# NOTE: sourcing allows to keep the Python venv active.


scripts=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
myenv=$(cd $(dirname $(dirname $scripts)) && pwd)
venv=$myenv/venv


. $scripts/lib/log.sh


has_ansible() {
  which ansible > /dev/null && which ansible-playbook > /dev/null && return
  return 1
}


ensure_venv() {

  $scripts/ensure-python.sh || return 1

  [[ ! -z ${VIRTUAL_ENV:-} ]] && OK "Python venv is active." && return

  if [[ ! -x $venv/bin/python ]] || [[ ! -f $venv/bin/activate ]]
  then
    INFO "Creating Python venv."
    python -m venv $venv || return 2
  fi

  INFO "Activating Python venv."
  . $venv/bin/activate

  [[ ! -z ${VIRTUAL_ENV:-} ]] && OK "Python venv is active." && return

  ERR "Activating Python venv failed!"
  return 3
}


install_ansible() {

  INFO "Installing Ansible."

  python -m pip install --upgrade pip

  # Latest Cryptography version that can be installed without Rust.
  # TODO: ensure `pyconfig.h` (python3-dev package).
  # TODO: Check that Rust exists.
  export CRYPTOGRAPHY_DONT_BUILD_RUST=1
  python -m pip install cryptography==3.4.8

  # This Ansible version depends on any Cryptography version.
  python -m pip install ansible==4.10.0
}

if ! has_ansible
then
  ensure_venv || exit 1

  if ! has_ansible
  then
    install_ansible || exit 2

    if ! has_ansible
    then
      ERR "Cannot ensure the Ansible!"
      exit 3
    fi
  fi
fi

OK "Ansible ready."
