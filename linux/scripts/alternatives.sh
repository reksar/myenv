#!/bin/bash


alt_max_priority() {
  local name=$1

  # Suppress stderr to get empty $info on err.
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

  local link=/usr/bin/$name
  local priority=`alt_increment_priority $name`

  update-alternatives --force --install $link $name $path $priority
}
