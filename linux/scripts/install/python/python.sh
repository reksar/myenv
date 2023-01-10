#!/bin/bash

# Ensures that `python --version` >= `MIN_PY_VERSION`.

MIN_PY_VERSION=3.11

scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)
version_check=$scripts/version.py

. $scripts/lib/log.sh
. $scripts/lib/alt.sh
. $scripts/lib/bool.sh


check() {
  local python=$1
  is_runnable $python \
    && $python $version_check $MIN_PY_VERSION \
    && OK "$python ready." \
    && return
  return 1
}


update_alternatives() {
  # Update the `python` alternative for `python3`.
  # The is no valid `python`, but the `python3` is OK.
  alt_install python `which python3` && return || return 1
}


install_python() {

  # Python will be installed using `pyenv`, not a package manager.
  $scripts/install/pyenv/pyenv.sh || return 1

  # Init `pyenv` if the shell was not restarted after installing `pyenv`.
  # The `.bashrc` usually prevents non-interactive execution, so `pyenvrc` is
  # used instead.
  . $scripts/install/pyenv/pyenvrc || return 2

  # Latest matched Python version available with `pyenv`.
  local ver=`pyenv install -l | grep "^\s*$MIN_PY_VERSION[.0-9]*$" | tail -1`

  INFO "Checking that Python $ver exists but not set as pyenv global."
  pyenv versions | grep $ver \
    && pyenv global $ver \
    && OK "Python $ver was set as pyenv global." \
    && return

  INFO "Installing Python $ver with pyenv."
  pyenv install $ver \
    && pyenv global $ver \
    && OK "Python $ver installed as pyenv global." \
    && return

  ERR "Cannot install the Python $ver with pyenv!"
  return 3
}


check python && exit
check python3 && update_alternatives && check python && exit
install_python && check python && exit
exit 1
