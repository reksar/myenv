# The `is_term_colored` is predefined in .bashrc
if [ "$is_term_colored" = yes ]; then
  color='always'
else
  color='auto'
fi

# enable color support, add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls="ls --color=$color --group-directories-first"
	alias dir="dir --color=$color"
	alias vdir="vdir --color=$color"
	alias grep="grep --color=$color"
	alias fgrep="fgrep --color=$color"
	alias egrep="egrep --color=$color"
fi

# some more ls aliases
alias la='ls -A'
alias ll='ls -alF --time-style=long-iso'

if [ "$is_term_colored" = yes ]; then
  lll () {
    ll $@ | less -r
  }
fi

# REWRITES (!) current Git repo by a new, created from given subdir `$1`.
git-dir-as_repo () {
	git filter-branch --subdirectory-filter $1 -- --all
}
