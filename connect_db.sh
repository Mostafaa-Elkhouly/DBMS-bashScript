#! /usr/bin/bash

read -p "Enter DB Name: " name

if [[ -d $name && -e $name ]] ; then

            cd ./DB/$name
            . ./tableMenu.sh
            #menu tables file --> export PS3="$name> "
else
    echo ERROR: DB Not Found! 
fi
