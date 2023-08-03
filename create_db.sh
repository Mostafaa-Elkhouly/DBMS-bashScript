#! /usr/bin/bash

read -p "Enter DB Name: " name

if [[ -e "./DB/$name" ]] ; then
        echo ERROR: DB Exist!
else
        pattern="^[^0-9\s\/><\?*\#'\@\$\%\^\&\(\)\.]+$"

        if [ -z $name ]; then
                echo "Name should not be null."
        elif [[ $name =~ ^(\.|\.\.) ]]; then
                echo "Name should not start with '.' or '..'."
        elif [[ $name =~ ^[0-9] ]]; then
                echo "Name should not start with a number."
        elif [[ ! $name =~ $pattern ]]; then
                echo "Name contains invalid characters or spaces."
        else
                mkdir ./DB/$name 
        fi
fi

