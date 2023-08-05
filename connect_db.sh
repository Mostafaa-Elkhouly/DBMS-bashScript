#! /usr/bin/bash

read -p "Enter DB Name: " name

if [[ -d "./DB/$name" && -e "./DB/$name" ]] ; then

            clear
            ./tablemenu.sh $name
else
    echo ERROR: DB Not Found! 
fi


