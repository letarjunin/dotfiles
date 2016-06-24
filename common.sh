#!/bin/bash

all_files=".bashrc .bashrc.local .bash_aliases .bash_completion .bash_funcs .bash_profile .tmux.conf pb.rb pb_check.sh set_pb_wallpaper.rb  .vimrc.before.local .vimrc.local .tmuxinator/dead.yml .vimrc.bundles.local"

debug=true
debug()
{
    if [ "$debug" = true ]; then
        echo "Debug : $1"
    fi
}

