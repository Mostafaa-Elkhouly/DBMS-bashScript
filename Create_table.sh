#!/usr/bin/bash
source ./shared.sh

dbname=$1
cd "./DB/$dbname/"


function promptForPK
{
    echo "Make Current Column The Primary Key? "
    select ans in "yes" "no"
    do
        case $REPLY in
            1)  return 0
                ;;
            2)  return 1
                ;;
            *) echo -e "\e[31mERROR: Invalid Option\e[0m"
        esac
    done
}


function createTable
{
    while true; do
        read -r -p "Enter Table Name: " tableName

        if [ -f "$tableName" ]; then
            echo -e "\e[31mERROR: Table Name Already Exists!\e[0m"
            continue
        
        elif [[ "$(isValidString "$tableName")" -eq 1 ]]; then 
            echo -e "\e[31mERROR: Invalid Table Name!\e[0m"
            continue
        fi

        read -r -p "Enter Columns Number--> " columnsNumber
        
        while [[ "$(isInteger "$columnsNumber")" -eq 1 ]]; do
            read -r -p "INVALID VALUE! `echo $'\n '` Enter Columns Number--> " columnsNumber
        done

        typeset -i counter=0
        columnSchema=""
        primKey=''

        while [[ counter -lt columnsNumber ]]; do
            currCol=$(( counter+1 ))

            read -r -p "Enter Column [$currCol] Name--> " colName
            
            if  [[ "$(isValidString "$colName")" -eq 1 ]]; then
                echo -e "\e[31mERROR: Invalid Column Name!\e[0m"
                continue
            fi

            echo "Choose The Column [$currCol] Type: "
            select type in "int" "string"; do
                case $REPLY in
                    1|2) colType=$type
                        break ;;
                    *) echo -e "\e[31mERROR: Invalid Option\e[0m"
                esac
            done

            if [ -z "$primKey" ]; then
                promptForPK
                if [ $? -eq 0 ]; then
                    primKey=$colName
                    colName+="(PK)"
                fi
            fi

            if [[ counter -eq columnsNumber-1 ]]; then
                columnSchema+="$colName:$colType"
            else
                columnSchema+="$colName:$colType|"
            fi

            ((counter++))
        done

        echo "$columnSchema" >> "./$tableName"
        if [[ $? -eq 0 ]]; then
            echo -e "\e[32mTable $tableName was created successfully!\e[0m"
            break
        else
            echo -e "\e[31mERROR: Creating Table\e[0m"
        fi
    done
}

createTable