#!/bin/bash

# Sets the python alias to python3 if possible.


major_version() {
  echo $1 | grep -Eo '[0-9]{1,}' | head -1
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

. alternatives.sh
alt_install python $python3
