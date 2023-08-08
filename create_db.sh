#! /usr/bin/bash

read -r -p "Enter DB Name: " name

if [[ -e "./DB/$name" ]] ; then
        echo -e "\033[31mERROR: DB Exist!\033[0m"
else
        pattern="^[^0-9\/><\?*\#'\@\$\%\^\&\(\)\.]+$"

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

