#! /usr/bin/bash

read -r -p "Enter DB Name: " name

if [[ -d "./DB/$name" && -e "./DB/$name" ]] ; then

            clear
            ./tablemenu.sh $name
else
    echo -e "\e[31mERROR: DB Not Found!\e[0m"
 
fi


