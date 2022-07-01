#!/bin/bash

# Sets the python alias to python3 if possible.

major_version() {
  echo $1 | grep -Eo '[0-9]{1,}' | head -1
}

max_priority() {
  echo $1 | grep 'Priority:' | grep -Eo '[0-9]{1,}' | sort -n | tail -1
}

priority() {

  local priority=1

  alternatives=`update-alternatives --query $1`

  if [[ $? == 0 ]]
  then
    ((priority+=`max_priority "$alternatives"`))
  fi

  echo $priority
}


# Exit if major of `python --version` is 3.
if [[ `which python` ]]
then
  # Sometimes there is a `python` alias (e.g. in pyenv),
  # but calling it gives an error.

  python_version=`python --version`

  if [[ $? == 0 ]] && [[ `major_version "$python_version"` == 3 ]]
  then
    echo The python alias is already set to python3
    exit 0
  fi
fi

python3=`which python3`

if ! [[ $python3 ]]
then
  echo The python3 is not found
  exit 1
fi

update-alternatives --force --install /usr/bin/python python $python3 \
  `priority python`
