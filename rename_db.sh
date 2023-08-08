#! /usr/bin/bash

read -r -p "Enter DB Name: " name

if [[ -d "./DB/$name" && -e "./DB/$name" ]] ; then

    read -r -p "Enter DB New Name: " new_name
    mv ./DB/$name ./DB/$new_name

else
    echo -e "\033[31mERROR: DB Not Found!\033[0m"                  
fi