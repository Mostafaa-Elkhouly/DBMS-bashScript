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



function promptForPK
{
    echo "Make Current Column The Primary Key? "    
    select ans in "yes" "no"
    do 
        case $REPLY in 
        1)  return 0
            ;;
        2)  return 1
            ;;
        *) echo -e "\e[31mERROR: Invalid Option\e[0m"    
        esac
        
    done

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


function createTable
{   
    read -r -p "Enter Table Name--> " tableName
  
    if [ -f $tableName ]
    then 
        echo -e "\e[31mERROR: Table Name Already Exsits!\e[0m"
        return 1
    fi

    read -r -p "Enter Columns Number--> " columnsNumber
    
    while ! isInteger $columnsNumber
    do 
        read -r -p "INVALID VALUE! `echo $'\n '` Enter Columns Number--> " columnsNumber        
    done


    typeset -i counter=0
    columnSchema=""
    primKey=''
    while  [[ counter -lt columnsNumber ]]
    do
        currCol=$(( counter+1 ))
        
        read -r -p "Enter Column [$currCol] Name--> " colName
        echo "Choose The Column [$currCol] Type: "
        select type in "int" "string"
        do
            case $REPLY in 
                1|2) colType=$type
                    break ;;
                *) echo "Invalid Option"
            esac
        done 
        
        if [ -z $primKey ]
        then
            promptForPK
            if [ $? -eq 0 ] 
            then 
                primKey=$colName
                colName+="(PK)"
            fi  
        fi

        if [[ counter -eq columnsNumber-1 ]]; then
            columnSchema+="$colName:$colType"
        else    
            columnSchema+="$colName:$colType|"
        fi
        
        ((counter++))
    done

     
    echo $columnSchema >> "./$tableName"
    if [[ $? == 0 ]]
    then
        echo "Table $tableName was created successfully!"
    else
        echo -e "\e[31mERROR: Creating Table\e[0m"
    fi
}

createTable
