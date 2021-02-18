# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


#--- Bash promt customization. ------------------------------------------------

# set a fancy prompt
case "$TERM" in
  xterm-color|*-256color) is_color_promt=yes;;
esac

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

set_bash_prompt() {

  # Must come first!
  local last_status_code=$?

  # Colors
  local RED='\[\e[1;31m\]'
  local GREEN='\[\e[1;32m\]'
  local YELLOW='\[\e[1;33m\]'
  local WHITE='\[\e[1;37m\]'
  local RESET_COLOR='\[\e[0m\]'

  local exit_status_icon="$exit_status_color$exit_status_char"

  if [[ $EUID == 0 ]]; then
		# super user
		local host_color=$RED
    local host_name="\\h"
		local promt_marker='#'
  else
		local host_color=$WHITE
    local host_name="\\u@\\h"
		local promt_marker='$'
  fi

  if [[ $last_status_code == 0 ]]; then
    local status_color=$WHITE
		local status_text=""
  else
    local status_color=$RED
		local status_text="ERR $last_status_code "
  fi

  local last_status="$status_color$status_text"
  local working_dir="$YELLOW\\w "
  local git_branch="$GREEN$(parse_git_branch)"

  if test -z "$VIRTUAL_ENV" ; then
	  local python_venv=""
  else
		local python_venv="${YELLOW}[`basename \"$VIRTUAL_ENV\"`] "
  fi

  PS1="\n$working_dir$git_branch$python_venv$last_status$promt_marker "
  PS1+="$RESET_COLOR"
}

if [ "$is_color_promt" = yes ]; then
  PROMPT_COMMAND='set_bash_prompt'
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi


# enable color support, add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto --group-directories-first'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi


# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

unset is_color_promt


# some more ls aliases
alias ll='ls -alF --time-style=long-iso'
alias la='ls -A'
alias l='ls -CF'


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
	;;
esac


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

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

