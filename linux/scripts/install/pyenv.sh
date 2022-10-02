#!/bin/bash

dir0=`cd $(dirname $BASH_SOURCE[0]) && pwd`
scripts=`cd $(dirname $dir0) && pwd`
. $scripts/lib/log.sh


install_with_apt() {

  # NOTE: `llvm` is optional.
  local packages="
    curl
    wget
    git
    make
    build-essential
    tk-dev
    xz-utils
    zlib1g-dev
    libbz2-dev
    libffi-dev
    liblzma-dev
    libncursesw5-dev
    libreadline-dev
    libsqlite3-dev
    libssl-dev
    libxml2-dev
    libxmlsec1-dev
  "

  INFO "Installing with apt-get."
  sudo apt-get update \
    && sudo apt-get install -y $packages \
    && OK "Packages installed." \
    && return

  return 1
}


has() {
  which $1 > /dev/null && return || return 1
}


install_packages() {
  # See https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  INFO "Installing packages for building a Python."
  has apt-get && install_with_apt && return
  ERR "Cannot install packages!"
  return 1
}


plug_pyenv() {

  local bashrc=$HOME/.bashrc
  local pyenvrc=$dir0/pyenvrc

  INFO "Checking that pyenv is plugged in $bashrc"
  grep "export PYENV_ROOT=\"\$HOME/.pyenv\"" $bashrc \
    && grep "export PATH=\"\$PYENV_ROOT/bin:" $bashrc \
    && grep "eval \"\$(pyenv init --path)\"" $bashrc \
    && . $pyenvrc \
    && OK "pyenv already plugged." \
    && return

  INFO "Plugging pyenv into .bashrc"
  cat $pyenvrc >> $bashrc \
    && . $pyenvrc \
    && OK "pyenv plugged." \
    && return

  ERR "Cannot plug the pyenv!"
  return 1
}


install_pyenv() {
  local pyenv=$HOME/.pyenv
  if [[ -x $pyenv/bin/pyenv ]] && [[ `ls $pyenv/libexec | wc -l` -gt 20 ]]
  then
    OK "pyenv executables are exists."
  else
    INFO "Installing pyenv."
    curl https://pyenv.run | bash
  fi
}


ensure() {
  install_pyenv
  plug_pyenv || return 1
  install_packages || return 2
}


has pyenv && OK "pyenv ready." && exit
ensure && has pyenv && OK "pyenv ready." && exit
ERR "Cannot ensure the pyenv!"
exit 1
