#!/bin/bash

# Source this script before invoking the Ansible.
# NOTE: sourcing allows to keep the Python venv active.


scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)
myenv=$(cd $(dirname $(dirname $scripts)) && pwd)
venv=$myenv/venv

. $scripts/lib/log.sh
. $scripts/lib/bool.sh


ensure_venv() {

  $scripts/install/python/python.sh || return 1

  # Init `pyenv` if the shell was not restarted after installing `pyenv`.
  # The `.bashrc` usually prevents non-interactive execution, so `pyenvrc` is
  # used instead.
  . $scripts/install/pyenv/pyenvrc || return 2

  [[ ! -z ${VIRTUAL_ENV:-} ]] && OK "Python venv is active." && return

  if [[ ! -x $venv/bin/python ]] || [[ ! -f $venv/bin/activate ]]
  then
    INFO "Creating Python venv."
    python -m venv $venv || return 3
  fi

  INFO "Activating Python venv."
  . $venv/bin/activate

  [[ ! -z ${VIRTUAL_ENV:-} ]] && OK "Python venv is active." && return

  ERR "Activating Python venv failed!"
  return 4
}


install_ansible() {

  INFO "Installing Ansible."

  # Init `pyenv` if the shell was not restarted after installing `pyenv`.
  # The `.bashrc` usually prevents non-interactive execution, so `pyenvrc` is
  # used instead.
  . $scripts/install/pyenv/pyenvrc || return 1

  python -m pip install --upgrade pip

  # Latest Cryptography version that can be installed without Rust.
  # TODO: ensure `pyconfig.h` (python3-dev package).
  # TODO: Check that Rust exists.
  export CRYPTOGRAPHY_DONT_BUILD_RUST=1
  python -m pip install cryptography==3.4.8

  # This Ansible version depends on any Cryptography version.
  python -m pip install ansible==4.10.0
}


has_ansible || ensure_venv || exit 1
has_ansible || install_ansible || exit 2

has_ansible && OK "Ansible ready." && exit

ERR "Cannot ensure the Ansible!"
exit 3
