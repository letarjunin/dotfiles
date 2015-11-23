#!/usr/bin/env bash

source common.sh 

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

for link in $all_files ; do
    link_path=$HOME/$link
    if [ -L $link_path ]; then
        debug "Unlinking $link_path"
        rm $link_path
    fi
    if [ -d $link_path ]; then
        debug "Deleting $link_path"
        rm -rf $link_path
    fi
done


rm -rf $app_dir
echo "Uninstall complete!"
