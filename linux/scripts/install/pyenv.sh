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

  local destination=/usr/local/bin
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
    ERR "Cannot proceed without wget or curl!"
    return
  fi

  local tmp=/usr/tmp

  # The `curl` can be at the Windows system dir and `which curl` can give
  # "/cygdrive/c/Windows/system32/curl" or "C:\Windows\System32\curl.exe".
  if where curl | grep -i "windows[\/]system32[\/]curl" > /dev/null
  then
    # In this case we need a `prefix` for the `tmp` path.
    # The `env` output must contain some like "!D:=d:\path\to\cygwin".
    prefix=`env | grep ":=\w" | sed "s/^.*=//"`

    # // - replace every
    # / - slash
    # / - with
    # \\ - backslash
    local destination=$prefix${tmp////\\}\\
  else
    local destination=$tmp/
  fi

  INFO "Getting wget with curl."

  local url_base=https://mirrors.163.com/cygwin/x86_64/release

  for url in \
    wget/wget-1.21.3-1.tar.xz \
    libpsl/libpsl5/libpsl5-0.21.2-1.tar.xz \
    nettle/libnettle6/libnettle6-3.4.1-1.tar.xz \
    libmetalink/libmetalink3/libmetalink3-0.1.3-1.tar.xz \
    libidn2/libidn2_0/libidn2_0-2.3.2-1.tar.xz \
    gpgme/libgpgme11/libgpgme11-1.9.0-1.tar.xz \
    gnutls/libgnutls30/libgnutls30-3.6.9-1.tar.xz \
    c-ares/libcares2/libcares2-1.14.0-1.tar.xz
  do
    local source=$url_base/$url
    local filename=${url##*/}
    local package=$tmp/$filename
    local destfile=$destination$filename
    curl --silent --output "$destfile" $source
    tar -xf "$package" -C /
    rm "$package"
  done

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
