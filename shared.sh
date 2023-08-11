#! /usr/bin/bash

#all shared functinons goes here 

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
            echo -e "\e[31mERROR: You Must Enter a Unique Value For the PK Column\e[0m"
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