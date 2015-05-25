#!/bin/bash

source common.sh 

for link in $all_files ; do
    link_path=~/$link
    if [ -L $link_path ]; then
        debug "Unlinking $link_path"
        rm $link_path
    fi
done


if [ -d ~/.spf13-vim-3/ ]; then
    echo "Uninstalling spf13"
    chmod 760 ~/.spf13-vim-3/uninstall.sh
    ~/.spf13-vim-3/uninstall.sh
fi

echo "Uninstall complete!"
