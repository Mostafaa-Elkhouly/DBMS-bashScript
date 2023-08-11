#!/usr/bin/bash
source ./shared.sh

while true; do
    read -r -p "Enter DB Name: " name

    if [[ "$(is_Valid_String "$name")" -eq 0 ]]; then
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