# Boolean checks.


is_runnable() {
  which $1 > /dev/null 2>&1 && return 0 || return 1
}


is_cygwin() {
  uname | grep -i "^CYGWIN" > /dev/null && return 0 || return 1
}


is_venv() {
  [[ ! -z ${VIRTUAL_ENV:-} ]] && return 0 || return 1
}


has_ansible() {
  is_runnable ansible && is_runnable ansible-playbook && return 0 || return 1
}
