#!/usr/bin/bash

while true; do
    read -r -p "Enter DB Name: " name

    if [[ -n "$name" && -d "./DB/$name" && -e "./DB/$name" ]]; then
        clear
        ./tablemenu.sh "$name"
        break
    else
        echo -e "\e[31mERROR: DB Not Found!\e[0m"
    fi
done