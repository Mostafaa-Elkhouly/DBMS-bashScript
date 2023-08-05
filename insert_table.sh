#! /usr/bin/bash

dbname=$1
cd "./DB/$dbname/"

function isInteger
{   

    intPattern="^[0-9]+$"
    if [[ $1 =~ $intPattern ]]
    then
        return 0
    else 
        return 1
    fi
}



function getPK
{
    pk=$(
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
                        break
                    } 
                    i++
                }
            }
        }
        ' ./$1)
    
    echo $pk
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

function isValidString
{
    if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]
    then
        return 0
    else
        return 1
    fi
}


function insertIntoTable
{   
    read -p "Enter Table Name--> " tableName
  
    if [ -f $tableName ]; then

        pk=$(getPK $tableName)
        
        column_names=($(colnames $tableName))        

        record_values=""

        echo "Enter values of table columns"
        for index in ${!column_names[@]}
        do 
            column=${column_names[$index]}
            read -p "$column : " val
                
            if [ $index -eq $((${#column_names[@]} - 1)) ]; then
                record_values+="$val"
            else
                record_values+="$val|"
            fi
        done 
        
        echo $record_values >> ./$tableName

        echo "Data Inserted Successfully..."
    fi

}   
insertIntoTable
