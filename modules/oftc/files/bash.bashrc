# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt
PS1='\[\033[1m\][$?] \u@'${debian_chroot:+$debian_chroot.}'\h:\w \$\[\033[0m\] '

export PAGER='less'
export EDITOR='vim'

umask 022

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias agi='apt-get install'
alias agr='apt-get remove'
alias cp='cp -iv'
alias d='date'
alias dist-upgrade='apt-get dist-upgrade'
alias j='jobs -l'
alias l='ls -al'
alias ls='ls --color=auto -F'
alias man='man -LC'
alias md='mkdir'
alias mv='mv -iv'
alias o='$PAGER'
alias policy='apt-cache policy'
alias rd='rmdir'
#alias rm='rm -iv'
alias show='apt-cache show'
alias showpkg='apt-cache showpkg'
alias showsrc='apt-cache showsrc'
alias tree='tree -ACF'
alias update='apt-get update'

nd ()
{
    mkdir "$1" && cd "$1"
}

upgrade ()
{
    if [ "$*" ]; then
        set -- $(dpkg -l "$@" | grep ^ii | awk '{ print $2 }');
        if [ "$*" ]; then
            echo "apt-get install $@";
            apt-get install "$@";
        else
            echo "Nothing to upgrade";
        fi;
    else
        apt-get upgrade;
    fi
}

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi
