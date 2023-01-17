#!/bin/bash

MIN_PYTHON_VERSION=3.11

scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)

. "$scripts/lib/log.sh"
. "$scripts/lib/bool.sh"
. "$scripts/install/pyenv/ensure.sh"


is_python_version_ok() {
  local python=${1:-python}
  local scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)
  $python "$scripts/version.py" $MIN_PYTHON_VERSION && return 0 || return 1
}


ensure_python_version() {
  # Expect Python >= `$MIN_PYTHON_VERSION` already installed in the system or
  # with `pyenv`.

  # For system Python.
  is_python_version_ok && return 0

  # If system Python is not found.
  ensure_pyenv && is_python_version_ok && return 0

  ERR "Cannot ensure Python >= $MIN_PYTHON_VERSION"
  return 1
}
