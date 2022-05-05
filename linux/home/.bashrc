# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples.

# Usually the ~/.bash_profile (for tty login) and the ~/.profile (for desktop
# login) are sourcing the ~/.bashrc, so all stuff is here instead of
# separating it in 3 files.

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# Disable terminal freezing with Ctrl+S / Ctrl+Q
stty -ixon

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


# --- Bash prompt ------------------------------------------------------------

current_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

colored_bash_prompt() {

  # Must come first!
  local last_status_code=$?

  # Colors
  local RED='\[\e[1;31m\]'
  local GREEN='\[\e[1;32m\]'
  local YELLOW='\[\e[1;33m\]'
  local WHITE='\[\e[1;37m\]'
  local RESET_COLOR='\[\e[0m\]'

  local exit_status_icon="$exit_status_color$exit_status_char"

  if [[ $EUID == 0 ]]
  then
		# super user
		local host_color=$RED
    local host_name="\\h"
		local promt_marker='#'
  else
		local host_color=$WHITE
    local host_name="\\u@\\h"
		local promt_marker='$'
  fi

  if [[ $last_status_code == 0 ]]
  then
    local status_color=$WHITE
		local status_text=""
  else
    local status_color=$RED
		local status_text="ERR $last_status_code "
  fi

  local status="$status_color$status_text"
  local workdir="$YELLOW\\w "
  local git_branch="$GREEN$(current_git_branch)"

  if test -z "$VIRTUAL_ENV"
  then
	  local python_venv=""
  else
		local python_venv="${YELLOW}[`basename \"$VIRTUAL_ENV\"`] "
  fi

  PS1="\n$workdir$git_branch$python_venv$status$promt_marker "
  PS1+="$RESET_COLOR"
}

simple_bash_prompt() {

  if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]
  then
    # set variable identifying the chroot you work in
    local debian_chroot=$(cat /etc/debian_chroot)
  fi

  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
}

# ----------------------------------------------------------------------------


# --- Colors -----------------------------------------------------------------
export_gcc_colors() {
  GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32'
  GCC_COLORS+=':locus=01:quote=01'
  export GCC_COLORS
}

colorize() {

  case "$TERM" in
    xterm-color|*-256color)
      local is_term_colored=yes
      ;;
  esac

  if [ "$is_term_colored" = yes ]
  then
    PROMPT_COMMAND='colored_bash_prompt'
    export_gcc_colors
  else
    simple_bash_prompt
  fi
}

colorize
# ----------------------------------------------------------------------------


if [ -d ~/.pyenv ]
then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi

export PATH=".:$PATH"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]
then
  . ~/.bash_aliases
fi
