# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

source ~/.bashrc.local

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
vxport PATH=/home/local/ANT/arjunkar/tools/depot_tools:/apollo/env/SDETools/bin:~/Cloud9TiaAndroidClient-1.0/bin:/home/local/ANT/arjunkar/tools/depot_tools:/usr/local/bin:/usr/bin:/bin:/usr/lib/lightdm/lightdm:/home/local/ANT/arjunkar/tools/sdk/platform-tools:/usr/lib/eclipse:/usr/bin/eclipse/
export CCACHE_SLOPPINESS=include_file_mtime
case hB in *i*)
  ccache --max-size=30G;
esac
export PATH=/home/local/ANT/arjunkar/tools/depot_tools:/apollo/env/SDETools/bin:~/Cloud9TiaAndroidClient-1.0/bin:/home/local/ANT/arjunkar/.rvm/gems/ruby-2.2.1/bin:/home/local/ANT/arjunkar/.rvm/gems/ruby-2.2.1@global/bin:/home/local/ANT/arjunkar/.rvm/rubies/ruby-2.2.1/bin:/home/local/ANT/arjunkar/tools/depot_tools:/usr/local/bin:/usr/bin:/bin:/usr/lib/lightdm/lightdm:/home/local/ANT/arjunkar/tools/sdk/platform-tools:/usr/lib/eclipse:/home/local/ANT/arjunkar/.rvm/bin:/usr/bin/eclipse/
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=/home/local/ANT/arjunkar/tools/depot_tools:/home/local/ANT/arjunkar/tools/depot_tools:/apollo/env/SDETools/bin:/home/local/ANT/arjunkar/Cloud9TiaAndroidClient-1.0/bin:/home/local/ANT/arjunkar/.rvm/gems/ruby-2.2.1/bin:/home/local/ANT/arjunkar/.rvm/gems/ruby-2.2.1@global/bin:/home/local/ANT/arjunkar/.rvm/rubies/ruby-2.2.1/bin:/home/local/ANT/arjunkar/tools/depot_tools:/usr/local/bin:/usr/bin:/bin:/usr/lib/lightdm/lightdm:/home/local/ANT/arjunkar/tools/sdk/platform-tools:/usr/lib/eclipse:/home/local/ANT/arjunkar/.rvm/bin:/usr/bin/eclipse/
export CCACHE_SLOPPINESS=include_file_mtime
case hB in *i*)
  ccache --max-size=30G;
esac

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
