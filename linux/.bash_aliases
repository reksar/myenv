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

# some more ls aliases
alias ll='ls -alF --time-style=long-iso'
alias la='ls -A'

# REWRITES (!) current Git repo by a new, created from given subdir `$1`.
git-dir-as_repo () {
	git filter-branch --subdirectory-filter $1 -- --all
}

