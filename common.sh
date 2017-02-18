#!/bin/bash

app_dir="$HOME/.dot_vim"
vim_files=".vimrc .vimrc.bundles .vimrc.before .vimrc.before.local .vimrc.bundles.local .vimrc.local"
bash_files=".bashrc .bashrc.local .bash_aliases .bash_completion .bash_funcs .bash_profile"
tmux_files=".tmux.conf .tmux.conf.local .tmuxinator/dead.yml"
all_files="$vim_files $bash_files $tmux_files"

debug=true
debug()
{
    if [ "$debug" = true ]; then
        echo "Debug : $1"
    fi
}

