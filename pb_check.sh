#!/usr/bin/env bash
folder=$1
file=$2
while (true); do 
    if [[ -f "$folder/$file" ]]; then
        last_few=$( find $folder -mmin -3 -name *$file ); 
        if [[ -z "$last_few" ]]; then 
            ruby ~/pb.rb "echo Oh,crap. Need to reboot.";
            exit;
        else
            sleep 60
        fi;
    else
        echo "File not found"
        exit;
    fi;
done;

