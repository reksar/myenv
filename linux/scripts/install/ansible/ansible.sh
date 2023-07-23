#!/bin/bash

# Source this script before invoking the Ansible. Sourcing allows to keep the
# Python venv active.


scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)

. "$scripts/lib/log.sh"
. "$scripts/lib/bool.sh"
. "$scripts/install/python/version.sh"


ensure_venv() {

  is_venv \
    && is_python_version_ok \
    && OK "Python venv is active." \
    && return 0

  is_venv \
    && WARN "Deactivating old Python venv" \
    && deactivate

  "$scripts/install/python/python.sh" || return 1
  ensure_python_version || return 2

  local myenv=$(cd $(dirname $(dirname "$scripts")) && pwd)
  local venv="$myenv/venv"
  local activate="$venv/bin/activate"

  [[ ! -x "$venv/bin/python" ]] || [[ ! -f "$venv/bin/activate" ]] && {
    INFO "Creating Python venv." && python -m venv "$venv" || return 3
  }

  INFO "Activating Python venv."
  . $venv/bin/activate

  is_venv && OK "Python venv is active." && return 0

  ERR "Activating Python venv failed!"
  return 4
}


install_ansible() {

  INFO "Installing Ansible."

  python -m pip install --upgrade pip || return 1

  # Latest Cryptography version that can be installed without Rust.
  # TODO: ensure `pyconfig.h` (python3-dev package).
  # TODO: Check that Rust exists.
  export CRYPTOGRAPHY_DONT_BUILD_RUST=1
  python -m pip install cryptography==3.4.8 || return 2

  # This Ansible version depends on any Cryptography version.
  python -m pip install ansible==4.10.0 || return 3

  return 0
}


has_ansible || ensure_venv || exit 1
has_ansible || install_ansible || exit 2
has_ansible || ERR "Ansible is not available!" && exit 3
OK "Ansible is available."
