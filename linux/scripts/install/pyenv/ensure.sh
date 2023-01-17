#!/bin/bash

scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)

. "$scripts/lib/bool.sh"
. "$scripts/lib/log.sh"


ensure_pyenv() {
  # Init `pyenv` if the shell was not restarted after installing `pyenv`.
  # The `.bashrc` usually prevents non-interactive execution, so `pyenvrc` is
  # used instead.

  local scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)

  is_runnable pyenv || . "$scripts/install/pyenv/pyenvrc"
  is_runnable pyenv && return 0

  ERR "Cannot ensure pyenv!"
  return 1
}
