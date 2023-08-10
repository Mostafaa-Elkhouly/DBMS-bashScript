#!/usr/bin/bash

rgx="^[A-Za-z_][A-Za-z0-9_]+*$"

while true; do
    read -r -p "Enter DB Name: " name

    if [[ -d "./DB/$name" && -e "./DB/$name" ]]; then
        while true; do
            read -r -p "Enter DB New Name: " new_name
            if [[ $new_name =~ $rgx ]]; then
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