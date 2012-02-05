#!/bin/bash
# Script for converting "quota report" command output on EMC systems
#+to NetApp systems.

ARGS=1
emc=$1

# Checking arguments

if [ $# -ne "$ARGS" ]
then
    echo "What do you want to be converted?"
    echo "Usage: `basename $0` [file-name]"
    exit 1
fi


# Getting tree and volume values

tree=`cat $1 | egrep -o "/.*" | egrep -o "^\S*"`
vol=`cat $1 | egrep -o "/vol."`

# Substituting

cat $1 | grep '#' | tr -d "\|" | while read LINE; do
    num=`echo $LINE | egrep -o "#[0-9]+" | tr -d "#"`
    name=`ypcat -k passwd | grep :$num:| head -c 8`
    echo user "$LINE" | sed -e "s#\#$num#$name $vol $tree#" | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$8" "$9}'
done

exit 0