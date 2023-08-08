#! /usr/bin/bash

read -r -p "Enter DB Name: " name

if [[ -d "./DB/$name" && -e "./DB/$name" ]] ; then

            clear
            ./tablemenu.sh $name
else
    echo -e "\033[31mERROR: DB Not Found!\033[0m"
 
fi


