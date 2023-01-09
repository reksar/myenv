#!/bin/bash

# Installs required system packages to build Python, then installs `pyenv` and
# plugs it in `.bashrc`.


dir0=`cd $(dirname $BASH_SOURCE[0]) && pwd`
scripts=`cd $(dirname $(dirname $dir0)) && pwd`

. $scripts/lib/log.sh
. $scripts/lib/bool.sh


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
    alternatives
    curl
    git
    make
    automake
    binutils
    cygwin-devel
    gcc-core
    gcc-g++
    libbz2-devel
    libcurl4
    libcom_err2
    libidn12
    libidn2_0
    libisl23
    libcrypt2
    libgc1
    libgcrypt20
    libguile3.0_1
    libgpg-error0
    libgssapi_krb5_2
    libk5crypto3
    libkrb5_3
    libkrb5support0
    liblzma-devel
    libmpc3
    libncurses-devel
    libnghttp2_14
    libntlm0
    libopenldap2
    libpsl5
    libreadline7
    libreadline-devel
    libsasl2_3
    libsqlite3_0
    libsqlite3-devel
    libssh2_1
    libssl-devel
    libuuid-devel
    libunistring2
    libunistring5
    libffi-devel
    libbrotlicommon1
    libbrotlidec1
    libgsasl18
    libzstd1
    mingw64-x86_64-libffi
    w32api-runtime
    zlib
    zlib-devel
  "

  INFO "Installing with apt-cyg."
  apt-cyg install $packages \
    && OK "Packages installed." \
    && move_cygwin_packages \
    && return

  return 1
}


move_cygwin_packages() {
  # Some package files are misplaced by `apt-cyg`.
  local mingw=/usr/x86_64-w64-mingw32
  local cygwin=/usr/x86_64-pc-cygwin
  cp -r $mingw/sys-root/mingw/* /usr/local 2> /dev/null
  rm -rf $mingw $cygwin
}


ensure_apt_cyg() {

  ensure_wget

  runnable apt-cyg && return

  # Some ported third-party utils like *curl* or *wget* does not works
  # correctly with the abs UNIX-like paths, so instead of using abs `/path` we
  # need to `cd /` and use the relative `path`.
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
    OK "wget found."
    return
  fi

  # The `wget` is not found or broken.

  if ! runnable curl
  then
    # TODO: try `windows/scripts/download.bat`
    ERR "Cannot proceed without wget or curl!"
    return
  fi

  INFO "Getting wget with curl."
  local url=https://eternallybored.org/misc/wget/1.21.3/64/wget.exe

  # Some Windows ported third-party utils like *curl* or *wget* does not works
  # correctly with the abs UNIX-like paths, so instead of using abs `/path` we
  # need to `cd /` and use the relative `path`.
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


add_cygwin_hook() {
  # Adds a hook to change the `EXT_SUFFIX` in Python `configure` script when
  # building Python with `pyenv`.
  #
  # The `.pyenv/plugins/python-build/bin/python-build` script has a stub for
  # the `before_install_package()` hook, that is called in the `make_package()`
  # function.
  #
  # Replaces the hook `$stub` in the `$pyenv_script` with the real `$hook`
  # function from `$hook_script` file.
  #
  # NOTE: this hook is fragile, because Cygwin + GCC is not supported by the
  # CPython core team, see https://peps.python.org/pep-0011

  local pyenv_script=$HOME/.pyenv/plugins/python-build/bin/python-build

  # This `$stub` from the `$pyenv_script` will be replaced with `$hook`.
  local stub="before_install_package() {\n\s*local stub=1\n}"

  # NOTE: edit this file carefully! Mind the conversion of the `$hook_script`
  # contents to the `$hook` substitution string.
  local hook_script=$dir0/before_install_package

  # Join `$hook_script` lines using "\n" delimiter.
  local hook_line=`sed -z "s/\n/\\\\\n/g" "$hook_script"`

  # Escape chars listed in square brackets using "\". Escaped round brackets
  # are used to translate listed chars with "\1".
  local hook=`echo $hook_line | sed "s/\([&$./\"]\)/\\\\\\\\\1/g"`

  sed -z -i "s/$stub/$hook/" "$pyenv_script"
}


tweak_pyenv() {
  is_cygwin && add_cygwin_hook || return 1
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

  INFO "Plugging pyenv into $bashrc"
  cat $pyenvrc >> $bashrc \
    && . $pyenvrc \
    && OK "pyenv plugged." \
    && return

  ERR "Cannot plug the pyenv in $bashrc"
  return 1
}


ensure_pyenv() {
  # Install packages before pyenv! It is assumed that if the pyenv executables
  # are available, then the required packages are already installed.
  install_packages || return 1
  install_pyenv || return 2
  tweak_pyenv || return 3
  plug_pyenv || return 4
}


runnable pyenv && OK "pyenv ready." && exit
ensure_pyenv && runnable pyenv && OK "pyenv ready." && exit

ERR "Cannot ensure the pyenv!"
exit 1
