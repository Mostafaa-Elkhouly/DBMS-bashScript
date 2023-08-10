#!/usr/bin/bash

while true; do
    read -r -p "Enter DB Name: " name

    rgx="^[A-Za-z_][A-Za-z0-9_]+*$"

    if [[ $name =~ $rgx ]]; then
        if [[ -e "./DB/$name" ]]; then
            echo -e "\e[31mERROR: DB Exist!\e[0m"
        else
            mkdir "./DB/$name"
            echo -e "\e[32mSuccess: Database '$name' created.\e[0m"
            break
        fi
    else
        echo -e "\e[31mERROR: Invalid DB Name!\e[0m"
    fi
done