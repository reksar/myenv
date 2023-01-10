# Boolean checks.


is_runnable() {
  which $1 > /dev/null 2>&1 && return || return 1
}


is_cygwin() {
  uname | grep -i "^CYGWIN" > /dev/null && return || return 1
}


has_ansible() {
  is_runnable ansible && is_runnable ansible-playbook && return
  return 1
}
