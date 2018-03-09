
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias less='less -R'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias f="find | grep -i "

alias clean="echo 'adb shell pm clear com.amazon.cloud9';adb shell pm clear com.amazon.cloud9"

alias gitshow="echo 'git show --pretty=\"format:\" --name-only';git show --pretty=\"format:\" --name-only "
alias gg="git grep -i "
alias gf="git ls-files | grep -i"
alias gpr="git pull --rebase"
alias glog="git log --pretty=oneline"

alias b="ruby /home/local/ANT/arjunkar/Documents/ninja_exec.rb"

alias ss='echo "ssh -f u8cdcd44a400b59ea9d24.ant.amazon.com -L 24800:u8cdcd44a400b59ea9d24.ant.amazon.com:24800 -N";ssh -f u8cdcd44a400b59ea9d24.ant.amazon.com -L 24800:u8cdcd44a400b59ea9d24.ant.amazon.com:24800 -N'


alias adbc='echo "adb logcat -c"; adb logcat -c'
alias adbd='echo "adb logcat -d > silk.out"; adb logcat -d > silk.out; vim silk.out'


#Take screen shot
alias screen='adb shell screencap -p /sdcard/screen.png;adb pull /sdcard/screen.png;adb shell rm /sdcard/screen.png;'

#Create  new browser 
alias adbstart='adb shell am start -a android.intent.action.VIEW -d "www.bing.com" -W com.amazon.cloud9/.browsing.BrowserActivity'
#Kill
alias adbkill='adb shell am force-stop com.amazon.cloud9'
alias adbhome='adb shell am start -a android.intent.action.MAIN -c android.intent.category.HOME'

alias vi="nvim"
alias vim="nvim"
alias grep='grep --color=always'
export devdesk="dev-dsk-arjunkar-2a-62165ba1.us-west-2.amazon.com"
export devdesk2="dev-dsk-arjunkar-2b-db734069.us-west-2.amazon.com"

alias iceport='echo "ssh -f u8cdcd44a400b59ea9d24.ant.amazon.com -L 58440:u8cdcd44a400b59ea9d24.ant.amazon.com:58440 -N";ssh -f u8cdcd44a400b59ea9d24.ant.amazon.com -L 58440:u8cdcd44a400b59ea9d24.ant.amazon.com:58440 -N'

alias gs="gclient sync"

alias os='echo "adb shell am start -n com.amazon.cloud9/com.amazon.slate.SlateActivity";adb shell am start -n com.amazon.cloud9/com.amazon.slate.SlatePreferences'

alias co='git checkout'

# workspace

alias s="python ~/Documents/sync.py"

h() {
    echo "$(b -p)"
    $(b -p)
}

ggf() {
     if [ -z "$1"   ]
     then
         echo "Dude - pass a string to search!"
     else
         git grep -i $1 | fpp
         echo "Dude wtf!"
     fi
}

#Alias definitions for local machine
if [ -f ~/.bash_aliases_local  ]; then
    . ~/.bash_aliases_local
fi

alias big="cd /media/arjunkar/Extra/workspaces/"

alias gss="git status -uno"

alias rec="adb shell screenrecord –bit-rate 10000000 –verbose /sdcard/screencapt.mp4"

function cherryp {
    commit=$(git log -1 $1 | head -n 1| awk '{print $2}')
    echo "Cherry-picking $commit from $1"
    git cherry-pick $commit
}
