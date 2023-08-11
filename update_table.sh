#! /usr/bin/bash
source ./shared.sh

dbname=$1
cd "./DB/$dbname/"
export PS3="$dbname:updateTable> "


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

                                        echo -e "\e[31mERROR: You must enter an integer number, please try again ...\e[0m"

                                    elif [ -z "$check_if_pk_exist" ]; then

                                        echo -e "\e[31mERROR: PK not Found, Please Try Again ...\e[0m"
                                    fi
                                    read -r -p "Enter value of $column : " val
                                    check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$val")
                                    idval=$val
                                done
                            else
                                while [ "$(isInteger "$val")" -eq 1 ]
                                do
                                    echo -e "\e[31mERROR: You must enter an integer number, please try again ...\e[0m"
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

                                        echo -e "\e[31mERROR: You must enter an integer number, please try again ...\e[0m"

                                    elif [ -z "$check_if_pk_exist" ]; then

                                        echo -e "\e[31mERROR: PK not Found, Please Try Again ...\e[0m"
                                    fi                                   
                                    read -r -p "Enter value of $column : " val
                                    check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$val")
                                    idval=$val
                                done
                            else
                                while [ "$(isValidString "$val")" -eq 1 ]
                                do
                                    echo -e "\e[31mERROR: You must enter a valid string, please try again ...\e[0m"
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
                                echo -e "\e[31mERROR: PK not Found, Please Try Again ...\e[0m"
                                read -r -p "Enter value of ${pk[0]}: " pkval
                                check_if_pk_exist=$(cut -d'|' -f ${pk[1]} ./$tableName | sed "1d" | grep -w "$pkval")
                                idval=$pkval
                            done

                            read -r -p "Enter Value of Column $var: " colval

                            if [[ ${column_types[$index]} = "int" ]]; then
                                
                                while [ "$(isInteger "$colval")" -eq 1 ]
                                do
                                    echo -e "\e[31mERROR: You must enter an integer number, please try again ...\e[0m"
                                    read -r -p "Enter value of $var : " colval
                                done
                            else 
                                while [ "$(isValidString "$colval")" -eq 1 ]
                                do
                                    echo -e "\e[31mERROR: You must enter a valid string, please try again ...\e[0m"
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
                echo -e "\e[31mERROR: Invalid selection\e[0m"
            fi
        done       
        
    else 
        echo -e "\e[31mERROR: Table" $tableName "Not Found!\e[0m"
    fi
}   

updateTable
