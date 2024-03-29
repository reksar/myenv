# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples.

# Usually the ~/.bash_profile (for tty login) and the ~/.profile (for desktop
# login) are sourcing the ~/.bashrc, so all stuff is here instead of separating
# it in 3 files.

# If not running interactively, don't do anything.
case $- in
	*i*) ;;
	*) return;;
esac

# Alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
[ -f ~/.bash_aliases ] && . ~/.bash_aliases


# Settings {{{

# Disable terminal freezing with Ctrl+S / Ctrl+Q.
stty -ixon

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options.
HISTCONTROL=ignoreboth

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it.
shopt -s histappend

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will match all
# files and zero or more directories and subdirectories.
#shopt -s globstar

# Settings }}}


# Bash prompt {{{

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
  local git_branch="$GREEN$(git-current-branch)"

  if test -z "$VIRTUAL_ENV"
  then
	  local python_venv=""
  else
		local python_venv="${YELLOW}[`basename \"$VIRTUAL_ENV\"`] "
  fi

  PS1="\n$workdir$git_branch$python_venv$status$promt_marker "
  PS1+="$RESET_COLOR"
}


static_bash_prompt() {

  if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]
  then
    # set variable identifying the chroot you work in
    local debian_chroot=$(cat /etc/debian_chroot)
  fi

  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
}

# Bash prompt }}}


# Colors {{{

if [[ "$is_term_colored" == "yes" ]]
then
  PROMPT_COMMAND=colored_bash_prompt

  GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01'
  GCC_COLORS+=':quote=01'
  export GCC_COLORS
else
  static_bash_prompt
fi

# Colors }}}


# Make `less` more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable programmable completion features (you don't need to enable this, if
# it's already enabled in `/etc/bash.bashrc` and `/etc/profile` sources the
# `/etc/bash.bashrc`).
if ! shopt -oq posix
then
  if [ -f /usr/share/bash-completion/bash_completion ]
  then
    . /usr/share/bash-completion/bash_completion

  elif [ -f /etc/bash_completion ]
  then
    . /etc/bash_completion
  fi
fi

if [ -d $HOME/.pyenv ]
then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"

  # Load pyenv-virtualenv automatically
  #eval "$(pyenv virtualenv-init -)"
  #exec "$SHELL"
fi

# To run executable in the current dir without ./
export PATH=".:$PATH"
