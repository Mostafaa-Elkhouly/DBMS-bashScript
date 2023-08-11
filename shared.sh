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

