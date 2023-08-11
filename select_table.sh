#! /usr/bin/bash
source ./shared.sh

dbname=$1
cd "./DB/$dbname/"
export PS3="$dbname:selectFromTable> "


function selectFromTable
{   
    read -r -p "Enter Table Name: " tableName
  
    if [ -f $tableName ]; then
            
        column_names=($(colnames $tableName))        

        echo "** Select a Specific Column -OR- Select Record by PK -OR- Select All Columns **"
        select var in ${column_names[@]} "select record by PK" "select all"
        do
            if [ -n "$var" ]; then
                if [[ $var = "select record by PK" ]]; then
                    pk=($(getPK $tableName))
                    
                    read -r -p "Enter the value of ${pk[0]} : " idval

                    line_number=$(cut -d '|' -f ${pk[1]} ./$tableName | grep -n -w "$idval" | cut -d ':' -f 1)
                    
                    if [[ -n $line_number ]]; then
                        record_to_select=$(sed -n "${line_number}p" ./$tableName)
                        echo $record_to_select
                    else
                        echo -e "\e[31mERROR: Invalid PK Value\e[0m"
                    fi

                elif [[ $var = "select all" ]]; then
                    allData=$(sed -n '1!p' ./$tableName)
                    echo "$allData"
                else
                    for value in ${column_names[@]}
                    do 
                        if [[ $value = $var ]]; then

                            colData=$(awk -F "|" -v colnum="$REPLY" '
                            {
                                if (NR > 1)
                                {
                                    print $colnum
                                }
                            }' $tableName)
                            
                            echo "$colData"
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

selectFromTable
