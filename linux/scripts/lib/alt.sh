# Functions to work with the `update-alternatives`.


. $(cd $(dirname $BASH_SOURCE[0]) && pwd)/bool.sh


alt_max_priority() {

  local name=$1

  # Suppress `stderr` to get empty `info` on err.
  local info=`update-alternatives --query $name 2> /dev/null`

  if [[ $info ]]
  then
    echo $info | grep 'Priority:' | grep -Eo '[0-9]{1,}' | sort -n | tail -1
  else
    echo 0
  fi
}


alt_increment_priority() {
  local name=$1
  local priority=`alt_max_priority $name`
  ((priority+=1))
  echo $priority
}


alt_install() {

  local name=$1
  local path=$2
  local link=/usr/local/bin/$name
  local priority=`alt_increment_priority $name`

  if [ `id -u` -ne 0 ] && ! is_cygwin && is_runnable sudo
  then
    local sudo=sudo
  fi

  ${sudo:-} update-alternatives --force --install $link $name $path $priority \
    && return

  return 1
}
