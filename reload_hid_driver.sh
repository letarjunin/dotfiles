#!/bin/sh

rmmod hid_multitouch 
sleep 1
modprobe hid_multitouch 
