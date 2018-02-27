#!/bin/bash

source common.sh 

program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }

    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi

    return 0
}

backup_file_and_link()
{
    if program_exists "grealpath"; then
        local realpath='grealpath'
    else
	local realpath='realpath'
    fi
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
        ln -s $($realpath $link_from) $backup_from
    fi
    echo ""
}

install_all_plugs() {
    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    vim \
        -u "~/.vimrc.plug.support" \
        "+set nomore" \
        "+PlugInstall!" \
        "+PlugClean" \
        "+qall"

    export SHELL="$system_shell"

    debug "All Plugs have been updated"
}

setup_plug()
{
    # Setup plug for new vim
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Setup plug for vim too! Ah, you know, safety!
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    install_all_plugs

}

create_nvim_folder() 
{
    mkdir -p ~/.config/nvim
}

echo ""

create_nvim_folder

for link in $all_files ; do
    echo "Installing $link"
    backup_file_and_link $link
done

setup_plug


echo ""
echo "DONE!"


