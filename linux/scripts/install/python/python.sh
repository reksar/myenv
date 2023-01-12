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


rename_lib_config_dir() {
  # Renames dir `.pyenv/versions/x.y.z/lib/pythonx.y/config-x.y`
  # to `.pyenv/versions/x.y.z/lib/pythonx.y/config`.

  local lib_base="$1"
  local ver_xy=$2

  local lib="$lib_base/python$ver_xy"

  [ ! -d "$lib" ] \
    && ERR "Python lib dir not found: $lib" \
    && return 3

  [ -d "$lib/config" ] \
    && INFO "Python lib config already has a valid name." \
    && return 0

  local config_pattern=config-$ver_xy*
  local config=`ls -d1 "$lib"/$config_pattern | head -1`

  [ ! -d "$config" ] \
    && ERR "Dir not found: $lib/$config_pattern" \
    && return 4

  cp -r "$config" "$lib/config" \
    && rm -rf "$config" \
    && OK "Python lib config dir has been renamed." \
    && return 0

  ERR "Cannot rename the $config"
  return 5
}


link_libpython_for_cygwin() {

  local lib="$1"
  local ver_xy=$2

  local libpython=libpython$ver_xy.dll.a

  local destination_file="$lib/$libpython"

  [ -e "$destination_file" ] \
    && OK "Already exists: $destination_file" \
    && return 0

  local source_file="$lib/python$ver_xy/config/$libpython"

  [ ! -e "$source_file" ] \
    && ERR "Not found: $source_file" \
    && return 1

  ln -s "$source_file" "$destination_file" && return 0

  ERR "Cant link the $source_file at $lib"
  return 2
}


tweak_python_lib_for_cygwin() {
  # This is a logical continuation of the `modify_ext_suffix()` from the
  # `$scripts/install/pyenv/before_install_package`, but this part can be done
  # without modifying `pyenv`.

  local ver_xyz=$1

  [[ ! $ver_xyz =~ ^[0-9]+.[0-9]+.[0-9]+$ ]] \
    && ERR "Python version $ver_xyz does follow the X.Y.Z format!" \
    && return 1

  local ver_xy=${ver_xyz%.*}

  [[ ! $ver_xy =~ ^[0-9]+.[0-9]+$ ]] \
    && ERR "Cannot reduce the Python version to X.Y" \
    && return 2

  local lib="$HOME/.pyenv/versions/$ver_xyz/lib"

  rename_lib_config_dir "$lib" $ver_xy || return 3
  link_libpython_for_cygwin "$lib" $ver_xy || return 4
  return 0
}


tweak_python() {
  # Tweak the Python installed in `.pyenv/versions/$ver`.
  local ver=$1
  is_cygwin && tweak_python_lib_for_cygwin $ver || return 1
  return 0
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
    && tweak_python $ver \
    && OK "Python $ver installed as pyenv global." \
    && return

  ERR "Cannot install the Python $ver with pyenv!"
  return 3
}


check python && exit
check python3 && update_alternatives && check python && exit
install_python && check python && exit
exit 1
