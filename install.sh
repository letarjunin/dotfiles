#!/bin/bash

source common.sh 

backup_file_and_link()
{
    backup_from=~/$1
    if [ -f "$backup_from" ]; then
        if [ ! -L $backup_from ]; then
            date_var=`date +%Y_%m_%d`
            debug "  Backing up $backup_from"
            backup_to=$backup_from.$date_var
            mv $backup_from $backup_to
        fi
    fi

    if [ ! -L $backup_from ]; then
        link_from=$1
        debug "  Linking from $link_from to $backup_from"
        ln -s $(realpath $link_from) $backup_from
    fi
    echo ""
}

echo ""
mkdir -p ~/.tmuxinator/ #Force create dir, easier to link.

for link in $all_files ; do
    echo "Installing $link"
    backup_file_and_link $link
done

echo "Installing dot_vim - this may take a while.."
./install_dot_vim.sh

echo ""
echo "DONE!"


