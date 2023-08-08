#! /usr/bin/bash

dbname=$1
cd "./DB/$dbname/"
export PS3="$dbname> "

function isInteger {   
    intPattern="^[0-9]+$"
    if [[ $1 =~ $intPattern ]]; then
        echo 0
    else 
        echo 1
    fi
}

function isValidString {
    if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]
    then
        echo 0
    else
        echo 1
    fi
}

function getPK {
    pk=(
        $( 
            awk '
            BEGIN{FS="|"}
            {
                if(NR == 1)
                {
                    i=1
                    while(i<=NF){ 
                        split($i, column, ":")
                        column_name = column[1]
                        column_type = column[2]

                        if ( column_name ~ /(PK)/ )
                        {
                            print column_name
                            print i 
                            break
                        }
                        i++
                    }
                }
            }
            ' ./$1
        )
    )
    
    echo ${pk[@]}
}

function colnames {

    column_names=(
    $(
        awk -F "|" '
        {
            if(NR == 1){
                for (i = 1; i <= NF; i++) {
                    split($i, parts, ":")
                    print parts[1]
                }
            }
        }' ./$1))
    
    echo ${column_names[@]}
}

function coltypes {

    column_types=(
    $(
        awk -F "|" '
        {
            if(NR == 1){
                for (i = 1; i <= NF; i++) {
                    split($i, parts, ":")
                    print parts[2]
                }
            }
        }' ./$1))
    
    echo ${column_types[@]}
}

function deleteFromTable
{   
    read -r -p "Enter Table Name: " tableName

    if [[ -f $tableName && -n $tableName ]]; then
    
        pk=($(getPK $tableName))
        
        column_names=($(colnames $tableName))  

        column_types=($(coltypes $tableName))        

        echo "**Delete Row By PK**"
        
        read -r -p "Enter value of ${pk[0]} : " val
        pk_index=${pk[1]}

        if [[ ${column_types[$pk_index]} = "int" ]]; then

            check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$val")
            idval=$val

            while [[ "$(isInteger "$val")" -eq 1 || -z "$check_if_pk_exist" ]]
            do
                if [ "$(isInteger "$val")" -eq 1 ]; then

                    echo -e "\033[31mERROR: You must enter an integer number, please try again ...\033[0m"

                elif [ -z "$check_if_pk_exist" ]; then

                    echo -e "\033[31mERROR: PK not Found, Please Try Again ...\033[0m"
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

                    echo -e "\033[31mERROR: You must enter an integer number, please try again ...\033[0m"

                elif [ -z "$check_if_pk_exist" ]; then

                    echo -e "\033[31mERROR: PK not Found, Please Try Again ...\033[0m"
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

        echo -e "\033[31mERROR: Table" $tableName "Not Found!\033[0m"
    fi
}   

deleteFromTable
