#! /usr/bin/bash

dbname=$1
cd "./DB/$dbname/"
export PS3="$dbname> "

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

function selectFromTable
{   
    read -r -p "Enter Table Name: " tableName
  
    if [ -f $tableName ]; then
            
        column_names=($(colnames $tableName))        

        echo "**Select a Specific Column Data -OR- Select All Columns Data **"
        select var in ${column_names[@]} "select all"
        do
            if [ -n "$var" ]; then
                if [[ $var = "select all" ]]; then
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
                echo -e "\033[31mERROR: Invalid selection\033[0m"
            fi
        done 

    else 
        echo -e "\033[31mERROR: Table" $tableName "Not Found!\033[0m"
    fi
}   

selectFromTable
