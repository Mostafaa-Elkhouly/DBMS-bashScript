#! /usr/bin/bash

read -p "Enter DB Name: " name

if [[ -d "./DB/$name" && -e "./DB/$name" ]] ; then

    read -p "Enter DB New Name: " new_name
    mv ./DB/$name ./DB/$new_name

else
    echo ERROR: DB Not Found!                  
fi