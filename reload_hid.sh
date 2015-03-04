#!/bin/sh

#Have the multitouch driver reloaded, so that trackpad works after sleep.

case "$1" in
    thaw|resume)
        rmmod hid_multitouch 
        sleep 1
        modprobe hid_multitouch 
        ;;
    *)
        ;;
esac
exit $?


