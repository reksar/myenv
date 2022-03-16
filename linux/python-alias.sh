#!/bin/bash

# Sets the python alias to python3 if possible.

major_version() {
  $1 --version | grep -Eo '[0-9]{1,}' | head -1
}

if [[ `which python` ]] && [[ `major_version python` == 3 ]]
then
  echo The python alias is already set to python3
  exit 0
fi

python3=`which python3`

if ! [[ $python3 ]]
then
  echo The python3 is not found
  exit 1
fi

update-alternatives --force --install /usr/bin/python python $python3 3
