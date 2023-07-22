#!/bin/bash

scripts=$(cd $(dirname $(dirname $(dirname $BASH_SOURCE[0]))) && pwd)
. "$scripts/lib/log.sh"
. "$scripts/lib/bool.sh"

user=`whoami`

[[ $user == "root" ]] && ERR "Installing sudo as root!" && exit 1

is_sudoer=`groups $user | grep sudo`

[[ -n $is_sudoer ]] && is_runnable sudo && OK "$user is sudoer" && exit 0

INFO "Installing sudo for $user as root"

install_sudo="apt-get -y update && apt-get -y install sudo"
[[ -z $is_sudoer ]] && install_sudo="$install_sudo && usermod -aG sudo $user"

su - -c "$install_sudo" || { ERR "Can't install sudo for $user"; exit 1; }

OK "sudo has been installed for $user"
[[ -z $is_sudoer ]] && INFO "You probably need to update the group memberships"
