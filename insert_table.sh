#! /usr/bin/bash

dbname=$1
cd "./DB/$dbname/"

function isInteger
{   
    intPattern="^[0-9]+$"
    if [[ $1 =~ $intPattern ]]; then
        echo 0
    else 
        echo 1
    fi
}

function isValidString
{
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

function checkForUniqueInPK {

    columnvalues=($( awk -F "|" -v colnum="$2" '{
        if(NR > 1)
        {
            print $colnum
        }
    }' $3
    ))

    for value in ${columnvalues[@]}
    do
        if [[ $1 -eq $value ]]; then
            echo "ERROR: You Must Enter a Unique Value For the PK Column"
            return 1
        fi
    done
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

function insertIntoTable
{   
    read -p "Enter Table Name--> " tableName
  
    if [ -f $tableName ]; then
    
        pk=($(getPK $tableName))
        
        column_names=($(colnames $tableName))        

        column_types=($(coltypes $tableName))        

        record_values=""

        echo "** Enter values of table columns **"
        for index in ${!column_names[@]}
        do 
            column=${column_names[$index]}
            read -p "$column : " val

            # if [[ $column = ${pk[0]} ]]; then

            #     checkForUniqueInPK $val ${pk[1]} $tableName

            #     while [ $? -eq 1 ]
            #     do
            #         read -p "$column : " val

            #         checkForUniqueInPK $val ${pk[1]} $tableName
            #     done
            
            # fi

            if [[ ${column_types[$index]} = "int" ]]; then

                if [[ $column = ${pk[0]} ]]; then
                    
                    checkForUniqueInPK $val ${pk[1]} $tableName
                    checkUniqueStatus=$?

                    while [[ "$(isInteger "$val")" -eq 1 || "$checkUniqueStatus" -eq 1  ]]
                    do
                        if [ "$(isInteger "$val")" -eq 1 ]; then

                            echo "You must enter an integer number, please try again!"
                        fi
                        read -p "$column : " val
                        checkForUniqueInPK $val ${pk[1]} $tableName
                        checkUniqueStatus=$?
                    done
                else
                    while [ "$(isInteger "$val")" -eq 1 ]
                    do
                        echo "You must enter an integer number, please try again!"
                        read -p "$column : " val
                    done
                fi
            else 
                if [[ $column = ${pk[0]} ]]; then
                    
                    checkForUniqueInPK $val ${pk[1]} $tableName
                    checkUniqueStatus=$?

                    while [[ "$(isValidString "$val")" -eq 1 || "$checkUniqueStatus" -eq 1  ]]
                    do
                        if [ "$(isValidString "$val")" -eq 1 ]; then

                            echo "You must enter an integer number, please try again!"
                        fi
                        read -p "$column : " val
                        checkForUniqueInPK $val ${pk[1]} $tableName
                        checkUniqueStatus=$?
                    done
                else
                    while [ "$(isValidString "$val")" -eq 1 ]
                    do
                        echo "You must enter a valid string, please try again!"
                        read -p "$column : " val
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
    fi

}   
insertIntoTable
