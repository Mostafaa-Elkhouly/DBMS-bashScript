#! /usr/bin/bash
source ./shared.sh

dbname=$1
cd "./DB/$dbname/"
export PS3="$dbname> "


function insertIntoTable
{   
    read -r -p "Enter Table Name: " tableName
  
    if [ -f $tableName ]; then
    
        pk=($(getPK $tableName))
        
        column_names=($(colnames $tableName))        

        column_types=($(coltypes $tableName))        

        record_values=""

        echo "** Enter values of table columns **"
        for index in ${!column_names[@]}
        do 
            column=${column_names[$index]}
            read -r -p "$column : " val

            if [[ ${column_types[$index]} = "int" ]]; then

                if [[ $column = ${pk[0]} ]]; then
                    
                    checkForUniqueInPK $val ${pk[1]} $tableName
                    checkUniqueStatus=$?

                    while [[ "$(isInteger "$val")" -eq 1 || "$checkUniqueStatus" -eq 1  ]]
                    do
                        if [ "$(isInteger "$val")" -eq 1 ]; then

                            echo -e "\e[31mERROR: You must enter an integer number, please try again!\e[0m"
                        fi
                        read -r -p "$column : " val
                        checkForUniqueInPK $val ${pk[1]} $tableName
                        checkUniqueStatus=$?
                    done
                else
                    while [ "$(isInteger "$val")" -eq 1 ]
                    do
                        echo -e "\e[31mERROR: You must enter an integer number, please try again!\e[0m"
                        read -r -p "$column : " val
                    done
                fi
            else 
                if [[ $column = ${pk[0]} ]]; then
                    
                    checkForUniqueInPK $val ${pk[1]} $tableName
                    checkUniqueStatus=$?

                    while [[ "$(isValidString "$val")" -eq 1 || "$checkUniqueStatus" -eq 1  ]]
                    do
                        if [ "$(isValidString "$val")" -eq 1 ]; then

                            echo -e "\e[31mERROR: You must enter an integer number, please try again!\e[0m"
                        fi
                        read -r -p "$column : " val
                        checkForUniqueInPK $val ${pk[1]} $tableName
                        checkUniqueStatus=$?
                    done
                else
                    while [ "$(isValidString "$val")" -eq 1 ]
                    do
                        echo -e "\e[31mERROR: You must enter a valid string, please try again!\e[0m"
                        read -r -p "$column : " val
                    done
                fi
            fi

            if [ $index -eq $((${#column_names[@]} - 1)) ]; then
                record_values+="$val"
            else
                record_values+="$val|"
            fi
        done 
        
        echo $record_values >> ./$tableName

        echo "Data Inserted Successfully..."
    else 
        echo -e "\e[31mERROR: Table" $tableName "Not Found!\e[0m"
    fi
}   

insertIntoTable
