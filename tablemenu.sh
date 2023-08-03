#! /usr/bin/bash

dbname=$1
echo "Welcome to " $dbname "Database"
export PS3="$dbname> "

select var in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table"
do

    case $REPLY in	
    1)
        #create_table
        ;;
    2)
        #list_tables
        ;;
    3)
        #drop_table
        ;;
    4)
        #insert_into_table
        ;;
    5)
        #select_from_table
        ;;
    6)
        #delete_from_table
        ;;
    7)
        #update_table
        ;;
    *)
        echo "Wrong Answer, Please Enter a Number From 1 to 7"
        ;;
    esac
done 

