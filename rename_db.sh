#!/usr/bin/bash
source ./shared.sh

while true; do
    read -r -p "Enter DB Name: " name

    if [[ -n "$name" && -d "./DB/$name" && -e "./DB/$name" ]]; then
        while true; do
            read -r -p "Enter DB New Name: " new_name
            
            if [[ "$(is_Valid_String "$new_name")" -eq 0 ]]; then
                if [[ -d "./DB/$new_name" ]]; then
                    echo -e "\e[31mERROR: Database '$new_name' already exists.\e[0m"
                else
                    mv "./DB/$name" "./DB/$new_name"
                    echo -e "\e[32mSuccess: Database '$name' renamed to '$new_name'.\e[0m"
                    break
                fi
            else
                echo -e "\e[31mERROR: Invalid New DB Name!\e[0m"
            fi
        done
        break
    else
        echo -e "\e[31mERROR: DB Not Found!\e[0m"
    fi
done