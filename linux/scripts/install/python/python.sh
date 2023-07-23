#!/bin/bash

# Ensures that system `python --version` >= `$MIN_PYTHON_VERSION`.

scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)

. "$scripts/lib/log.sh"
. "$scripts/lib/alt.sh"
. "$scripts/lib/bool.sh"
. "$scripts/install/python/version.sh"


check() {
  local python=$1
  is_runnable $python \
    && is_python_version_ok $python \
    && OK "$python ready." \
    && return 0
  return 1
}


update_alternatives() {
  # Update the `python` alternative for `python3`.
  # The is no valid `python`, but the `python3` is OK.
  alt_install python `which python3` && return 0 || return 1
}


rename_lib_config_dir() {
  # Renames dir `.pyenv/versions/x.y.z/lib/pythonx.y/config-x.y`
  # to `.pyenv/versions/x.y.z/lib/pythonx.y/config`.

  local version_xyz=$1
  local version_xy=$2

  local lib="$HOME/.pyenv/versions/$version_xyz/lib/python$version_xy"

  [ ! -d "$lib" ] \
    && ERR "Python lib dir not found: $lib" \
    && return 3

  [ -d "$lib/config" ] \
    && INFO "Python lib config already has a valid name." \
    && return 0

  local config_pattern=config-$version_xy*
  local config=`ls -d1 "$lib"/$config_pattern | head -1`

  [ ! -d "$config" ] \
    && ERR "Dir not found: $lib/$config_pattern" \
    && return 4

  cp -r "$config" "$lib/config" && rm -rf "$config" && return 0

  ERR "Cannot rename the $config"
  return 5
}


copy_libpython_for_cygwin() {

  local version_xyz=$1
  local version_xy=$2

  local lib="$HOME/.pyenv/versions/$version_xyz/lib"

  local libpython=libpython$version_xy.dll.a

  local destination_file="$lib/$libpython"

  [ -e "$destination_file" ] \
    && OK "Already exists: $destination_file" \
    && return 0

  local source_file="$lib/python$version_xy/config/$libpython"

  [ ! -e "$source_file" ] \
    && ERR "Not found: $source_file" \
    && return 1

  cp "$source_file" "$destination_file" && return 0

  ERR "Cannot copy $source_file to $lib"
  return 2
}


rebase_libpython_for_cygwin() {
  # Fixes the availability of memory address space for this lib.

  local version_xyz=$1
  local version_xy=$2

  local filename="libpython$version_xy.dll"
  local libpython="$HOME/.pyenv/versions/$version_xyz/bin/$filename"

  rebase --database "$libpython" && return 0

  ERR "Cannot update rebase database for libpython DLL."
  return 1
}


tweak_python_lib_for_cygwin() {
  # This is a logical continuation of the `modify_ext_suffix()` from the
  # `$scripts/install/pyenv/before_install_package`, but this part can be done
  # without modifying `pyenv`.

  local version_xyz=$1

  [[ ! $version_xyz =~ ^[0-9]+.[0-9]+.[0-9]+$ ]] \
    && ERR "Python version $version_xyz does follow the X.Y.Z format!" \
    && return 1

  local version_xy=${version_xyz%.*}

  [[ ! $version_xy =~ ^[0-9]+.[0-9]+$ ]] \
    && ERR "Cannot reduce the Python version to X.Y" \
    && return 2

  rename_lib_config_dir $version_xyz $version_xy || return 3
  copy_libpython_for_cygwin $version_xyz $version_xy || return 4
  rebase_libpython_for_cygwin $version_xyz $version_xy || return 5
  return 0
}


tweak_python() {

  # Tweak the Python installed in `.pyenv/versions/$version`.
  local version=$1

  is_cygwin && {
    tweak_python_lib_for_cygwin $version && return 0 || return 1
  }

  return 0
}


install_python() {

  # Python will be installed using `pyenv`, not a package manager.
  "$scripts/install/pyenv/pyenv.sh" || return 1
  ensure_pyenv || return 2

  # Latest matched Python version available with `pyenv`.
  local version=`
    pyenv install -l | grep "^\s*$MIN_PYTHON_VERSION[.0-9]*$" | tail -1
  `

  INFO "Checking that Python $version exists but not set as pyenv global."
  pyenv versions | grep $version \
    && pyenv global $version \
    && OK "Python $version was set as pyenv global." \
    && return 0

  INFO "Installing Python $version with pyenv."
  pyenv install $version \
    && pyenv global $version \
    && tweak_python $version \
    && OK "Python $version installed as pyenv global." \
    && return 0

  ERR "Cannot install the Python $version with pyenv!"
  return 3
}


check python && exit 0
check python3 && update_alternatives && check python && exit 0
install_python && check python && exit 0
exit 1
