
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
        *) echo "Invalid Option"    
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
    dbName=$1
    echo $dbName
    read -p "Enter Table Name--> " tableName
  
    if [ -f "/DB/$dbName/$tableName" ]
    then 
        echo "Error! Table Name Already Exsits!"
        return 1
    fi

    read -p "Enter Columns Number--> " columnsNumber
    
    while ! isInteger $columnsNumber
    do 
        read -p "INVALID VALUE! `echo $'\n '` Enter Columns Number--> " columnsNumber        
    done


    typeset -i counter=0
    columnSchema=""
    primKey=''
    while  [[ counter -lt columnsNumber ]]
    do
        currCol=$(( counter+1 ))
        
        read -p "Enter Column [$currCol] Name--> " colName
        echo "Enter Column [$currCol] Type--> "
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

        
        columnSchema+="$colName:$colType|"
        
        ((counter++))
    done

     
    printf $columnSchema >> "DB/$dbName/$tableName"
    if [[ $? == 0 ]]
    then
        echo "Table $tableName was created successfully!"
    else
        echo ERROR Creating Table
    fi
}

# $1 is the Database Name
createTable $1
