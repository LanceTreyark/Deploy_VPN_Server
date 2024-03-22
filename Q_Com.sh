#!/bin/bash
#v.032124
date_time="$(date +"%m.%d.%y %I:%M%p")"
#read -p "Enter an additional commit message (optional)   " var_commit
echo "*"
git commit -m "$date_time" #$var_commit removed
echo "*  *"
echo "*  *  *"
sleep 1
echo "Script v.020523 Complete"

