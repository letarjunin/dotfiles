
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias less='less -R'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias f="find | grep -i "
alias gg="git grep -i "

alias clean="echo 'adb shell pm clear com.amazon.cloud9';adb shell pm clear com.amazon.cloud9"
alias gitshow="echo 'git show --pretty=\"format:\" --name-only';git show --pretty=\"format:\" --name-only "
alias b="ruby /home/local/ANT/arjunkar/Documents/ninja_exec.rb"

#alias ss='echo "ssh -f arjundesk.aka.amazon.com -L 24800:arjundesk.aka.amazon.com:24800 -N";ssh -f arjundesk.aka.amazon.com -L 24800:arjundesk.aka.amazon.com:24800 -N'
alias ss='echo "ssh -f acbc32871627.ant.amazon.com -L 24800:acbc32871627.ant.amazon.com:24800 -N";ssh -f acbc32871627.ant.amazon.com -L 24800:acbc32871627.ant.amazon.com:24800 -N'
