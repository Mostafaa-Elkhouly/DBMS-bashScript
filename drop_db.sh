#!/usr/bin/bash

while true; do
    read -r -p "Enter DB Name: " name

    if [[ -d "./DB/$name" && -e "./DB/$name" ]]; then
        rm -r "./DB/$name"
        echo -e "\e[32mSuccess: Database '$name' deleted.\e[0m"
        break
    else
        echo -e "\e[31mERROR: DB Not Found!\e[0m"
    fi
done