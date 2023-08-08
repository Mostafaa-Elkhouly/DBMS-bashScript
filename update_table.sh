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

function updateTable
{   
    read -r -p "Enter Table Name: " tableName

    if [[ -f $tableName && -n $tableName ]]; then
    
        pk=($(getPK $tableName))
        
        column_names=($(colnames $tableName))  

        column_types=($(coltypes $tableName))        

        record_values=""

        unset column_names[0]

        echo "**Select Specific Column to update -OR- Update All Columns Data **"
        select var in ${column_names[@]} "update all"
        do
            if [ -n "$var" ]; then
                if [[ $var = "update all" ]]; then
                    column_names=($(colnames $tableName))
                    idval=""  
                    for index in ${!column_names[@]}
                    do 
                        column=${column_names[$index]}
                        read -r -p "Enter value of $column : " val

                        if [[ ${column_types[$index]} = "int" ]]; then

                            if [[ $column = ${pk[0]} ]]; then

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
                                while [ "$(isInteger "$val")" -eq 1 ]
                                do
                                    echo -e "\033[31mERROR: You must enter an integer number, please try again ...\033[0m"
                                    read -r -p "Enter value of $column : " val
                                done
                            fi
                        else 
                            if [[ $column = ${pk[0]} ]]; then

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
                            else
                                while [ "$(isValidString "$val")" -eq 1 ]
                                do
                                    echo -e "\033[31mERROR: You must enter a valid string, please try again ...\033[0m"
                                    read -r -p "Enter value of $column : " val
                                done
                            fi
                        fi

                        if [ $index -eq $((${#column_names[@]} - 1)) ]; then
                            record_values+="$val"
                        else
                            record_values+="$val|"
                        fi
                    done 

                    #get record number of PK
                    col_num=${pk[1]}
                    line_number=$(cut -d '|' -f $col_num ./$tableName | grep -n -w "$idval" | cut -d ':' -f 1)

                    sed -i "${line_number}s/.*/$record_values/" ./$tableName
                    echo "Data Updated Successfully..."

                else
                    for index in ${!column_names[@]}
                    do 
                        if [[ ${column_names[$index]} = $var ]]; then

                            read -r -p "Enter value of ${pk[0]}: " pkval
                            check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$pkval")
                            idval=$pkval

                            while [[ -z "$check_if_pk_exist" ]]
                            do 
                                echo -e "\033[31mERROR: PK not Found, Please Try Again ...\033[0m"
                                read -r -p "Enter value of ${pk[0]}: " pkval
                                check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$pkval")
                                idval=$pkval
                            done

                            read -r -p "Enter Value of Column $var: " colval

                            if [[ ${column_types[$index]} = "int" ]]; then
                                
                                while [ "$(isInteger "$colval")" -eq 1 ]
                                do
                                    echo -e "\033[31mERROR: You must enter an integer number, please try again ...\033[0m"
                                    read -r -p "Enter value of $var : " colval
                                done
                            else 
                                while [ "$(isValidString "$colval")" -eq 1 ]
                                do
                                    echo -e "\033[31mERROR: You must enter a valid string, please try again ...\033[0m"
                                    read -r -p "Enter value of $var : " colval
                                done
                            fi

                            #get record number of PK
                            
                            line_number=$(cut -d '|' -f ${pk[1]} ./$tableName | grep -n -w "$idval" | cut -d ':' -f 1)
                            
                            col_num=$(($index+1))

                            # Update the value in the file using awk
                            awk -v row="$line_number" -v col="$col_num" -v val="$colval" '
                                BEGIN { FS="|" }
                                {   
                                    if (NR == row) { 
                                        $col = val
                                    }
                                    
                                    for (i = 1; i <= NF; i++) {
                                        printf "%s", $i
                                        if (i < NF) {
                                            printf "|"
                                        }
                                    }
                                    printf "\n"

                                } ' ./$tableName > ./temp

                                mv ./temp ./$tableName

                                echo "Data Updated Successfully..."

                            break
                        fi
                    done
                fi
            else
                echo -e "\033[31mERROR: Invalid selection\033[0m"
            fi
        done       
        
    else 
        echo -e "\033[31mERROR: Table" $tableName "Not Found!\033[0m"
    fi
}   

updateTable
