
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
alias gg="git grep -i "

alias clean="echo 'adb shell pm clear com.amazon.cloud9';adb shell pm clear com.amazon.cloud9"
alias gitshow="echo 'git show --pretty=\"format:\" --name-only';git show --pretty=\"format:\" --name-only "

alias b="ruby /home/local/ANT/arjunkar/Documents/ninja_exec.rb"

alias ss='echo "ssh -f u94de80b652ee58764c73.ant.amazon.com -L 24800:u94de80b652ee58764c73.ant.amazon.com:24800 -N";ssh -f u94de80b652ee58764c73.ant.amazon.com -L 24800:u94de80b652ee58764c73.ant.amazon.com:24800 -N'


alias adbc='echo "adb logcat -c"; adb logcat -c'
alias adbd='echo "adb logcat -d > silk.out"; adb logcat -d > silk.out; vim silk.out'


#Take screen shot
alias screen='adb shell screencap -p /sdcard/screen.png;adb pull /sdcard/screen.png;adb shell rm /sdcard/screen.png;'

#Create  new browser 
alias adbstart='adb shell am start -a android.intent.action.VIEW -d "www.bing.com" -W com.amazon.cloud9/.browsing.BrowserActivity'
#Kill
alias adbkill='adb shell am force-stop com.amazon.cloud9'
alias adbhome='adb shell am start -a android.intent.action.MAIN -c android.intent.category.HOME'
alias vi="vim"
alias grep='grep --color=always'
export devdesk="dev-dsk-arjunkar-2a-2bed2328.us-west-2.amazon.com"

alias iceport='echo "ssh -f u94de80b652ee58764c73.ant.amazon.com -L 58440:u94de80b652ee58764c73.ant.amazon.com:58440 -N";ssh -f u94de80b652ee58764c73.ant.amazon.com -L 58440:u94de80b652ee58764c73.ant.amazon.com:58440 -N'
