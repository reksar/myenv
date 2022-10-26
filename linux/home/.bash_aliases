case "$TERM" in
  xterm-color|*-256color)
    is_term_colored=yes
    ;;
esac

[[ "$is_term_colored" == "yes" ]] && color=always || color=auto

if [[ -x /usr/bin/dircolors ]]
then
  eval "$(dircolors -b $([[ -r ~/.dircolors ]] && echo ~/.dircolors))"
	alias ls="ls --color=$color --group-directories-first"
	alias dir="dir --color=$color"
	alias vdir="vdir --color=$color"
	alias grep="grep --color=$color"
	alias fgrep="fgrep --color=$color"
	alias egrep="egrep --color=$color"
fi

alias la='ls -A'
alias ll='ls -alF --time-style=long-iso'

if [[ "$is_term_colored" == "yes" ]]
then
  lll () {
    ll $@ | less -r
  }
fi

# REWRITE (!) current Git repo by a new, created from given subdir `$1`.
git-repo-here () {
	git filter-branch --subdirectory-filter $1 -- --all
}

git-current-branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
