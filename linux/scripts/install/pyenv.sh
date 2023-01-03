#!/bin/bash

dir0=`cd $(dirname $BASH_SOURCE[0]) && pwd`
scripts=`cd $(dirname $dir0) && pwd`

. $scripts/lib/log.sh
. $scripts/lib/runnable.sh


apt_get_packages() {

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


apt_cyg_packages() {

  local packages="
    curl
    git
    make
    automake
    gcc-core
    gcc-g++
    libcurl4
    libcom_err2
    libidn12
    libidn2_0
    libgcrypt20
    libgpg-error0
    libgssapi_krb5_2
    libk5crypto3
    libkrb5_3
    libkrb5support0
    libnghttp2_14
    libntlm0
    libopenldap2
    libpsl5
    libsasl2_3
    libssh2_1
    libunistring5
    libffi-devel
    libbrotlicommon1
    libbrotlidec1
    libgsasl18
    libzstd1
    zlib
    zlib-devel
  "

  INFO "Installing with apt-cyg."
  apt-cyg install $packages && OK "Packages installed." && return

  return 1
}


is_cygwin() {
  uname | grep -i "^CYGWIN" > /dev/null && return || return 1
}


ensure_apt_cyg() {

  ensure_wget

  runnable apt-cyg && return

  # Some ported UNIX-like utils like *curl* or *wget* does not works with abs
  # UNIX paths correctly, so instead of using abs `/usr` path we need to `cd /`
  # and use the relative `usr` path.
  cd /
  local destination=usr/local/bin

  local url=https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
  wget -P $destination $url

  runnable apt-cyg && return

  ERR "Cannot install apt-cyg!"
  return 1
}


ensure_wget() {

  if wget --help > /dev/null 2>&1
  then
    # OK
    return
  fi

  # The `wget` is not found or broken.

  if ! runnable curl
  then
    # TODO: try bat downloader.
    ERR "Cannot proceed without wget or curl!"
    return
  fi

  INFO "Getting wget with curl."
  local url=https://eternallybored.org/misc/wget/1.21.3/64/wget.exe

  # Some ported UNIX-like utils like *curl* or *wget* does not works with abs
  # UNIX paths correctly, so instead of using abs `/usr` path we need to `cd /`
  # and use the relative `usr` path.
  cd /
  local outfile=usr/local/bin/wget.exe

  curl --silent --output "$outfile" $url

  if wget --help > /dev/null 2>&1
  then
    OK "wget installed."
  else
    ERR "Cannot ensure the wget!"
  fi
}


install_packages() {

  # See https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  # NOTE: the llvm package is optional.
  INFO "Installing packages for building a Python with pyenv."

  runnable apt-get && apt_get_packages && return
  is_cygwin && ensure_apt_cyg && apt_cyg_packages && return

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

  ERR "Cannot plug the pyenv in $bashrc"
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
  # Install packages before pyenv! It is assumed that if the pyenv executables
  # are available, then the required packages are already installed.
  install_packages || return 1
  install_pyenv
  plug_pyenv || return 2
}


runnable pyenv && OK "pyenv ready." && exit
ensure && runnable pyenv && OK "pyenv ready." && exit
ERR "Cannot ensure the pyenv!"
exit 1
