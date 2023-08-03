#! /usr/bin/bash

read -p "Enter DB Name: " name

if [[ -d "./DB/$name"  && -e "./DB/$name" ]] ; then
    
    rm -r ./DB/$name

else
    echo ERROR: DB Not Found
fi