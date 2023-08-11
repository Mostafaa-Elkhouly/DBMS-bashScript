#! /usr/bin/bash
source ./shared.sh

dbname=$1
cd "./DB/$dbname/"
export PS3="$dbname> "


function deleteFromTable
{   
    read -r -p "Enter Table Name: " tableName

    if [[ -f $tableName && -n $tableName ]]; then
    
        pk=($(getPK $tableName))
        
        column_names=($(colnames $tableName))  

        column_types=($(coltypes $tableName))        

        echo "** Delete Record By PK **"
        
        read -r -p "Enter value of ${pk[0]} : " val
        pk_index=${pk[1]}

        if [[ ${column_types[$pk_index]} = "int" ]]; then

            check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$val")
            idval=$val

            while [[ "$(isInteger "$val")" -eq 1 || -z "$check_if_pk_exist" ]]
            do
                if [ "$(isInteger "$val")" -eq 1 ]; then

                    echo -e "\e[31mERROR: You must enter an integer number, please try again ...\e[0m"

                elif [ -z "$check_if_pk_exist" ]; then

                    echo -e "\e[31mERROR: PK not Found, Please Try Again ...\e[0m"
                fi
                read -r -p "Enter value of $column : " val
                check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$val")
                idval=$val
            done
        else 
            check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$val")
            idval=$val

            while [[ "$(isValidString "$val")" -eq 1 || -z "$check_if_pk_exist" ]]
            do
                if [ "$(isValidString "$val")" -eq 1 ]; then

                    echo -e "\e[31mERROR: You must enter an integer number, please try again ...\e[0m"

                elif [ -z "$check_if_pk_exist" ]; then

                    echo -e "\e[31mERROR: PK not Found, Please Try Again ...\e[0m"
                fi                                   
                read -r -p "Enter value of $column : " val
                check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$val")
                idval=$val
            done
        fi

        #get record number of PK
        col_num=${pk[1]}
        line_number=$(cut -d '|' -f $col_num ./$tableName | grep -n -w "$idval" | cut -d ':' -f 1)

        sed -i "${line_number}d" ./$tableName
        echo "Data Deleted Successfully..."

    else

        echo -e "\e[31mERROR: Table" $tableName "Not Found!\e[0m"
    fi
}   

deleteFromTable
