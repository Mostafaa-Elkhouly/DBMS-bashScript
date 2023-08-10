#!/usr/bin/bash

while true; do
    read -r -p "Enter DB Name: " name

    if [[ -e "./DB/$name" ]]; then
        echo -e "\e[31mERROR: DB Exist!\e[0m"
    else
        pattern="^[^0-9\/><\?*\#'\@\$\%\^\&\(\)\.]+$"

        if [ -z "$name" ]; then
            echo -e "\e[31mERROR: Name should not be null.\e[0m"
        elif [[ $name =~ ^(\.|\.\.) ]]; then
            echo -e "\e[31mERROR: should not start with '.' or '..'.\e[0m"
        elif [[ $name =~ ^[0-9] ]]; then
            echo -e "\e[31mERROR: Name should not start with a number.\e[0m"
        elif [[ ! $name =~ $pattern ]]; then
            echo -e "\e[31mERROR: Name contains invalid characters or spaces.\e[0m"
        else
            mkdir "./DB/$name"
            echo -e "\e[32mSuccess: Database '$name' created.\e[0m"  
            break  
        fi
    fi
done