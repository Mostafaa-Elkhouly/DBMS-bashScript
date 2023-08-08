#! /usr/bin/bash

read -r -p "Enter DB Name: " name

if [[ -d "./DB/$name" && -e "./DB/$name" ]] ; then

    read -r -p "Enter DB New Name: " new_name
    mv ./DB/$name ./DB/$new_name

else
    echo -e "\e[31mERROR: DB Not Found!\e[0m"                  
fi