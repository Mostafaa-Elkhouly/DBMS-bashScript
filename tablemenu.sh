#! /usr/bin/bash

dbname=$1
echo "Welcome to " $dbname "Database"
export PS3="$dbname> "

select var in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table"
do

    case $REPLY in	
    1)
        ./Create_table.sh $dbname
        ;;
    2)
        ls -F "./DB/$dbname" | grep -v /
        ;;
    3)
        ./drop_table.sh $dbname
        ;;
    4)
        ./insert_table.sh $dbname
        ;;
    5)
        ./select_table.sh $dbname
        ;;
    6)
        ./delete_from_table.sh $dbname
        ;;
    7)
        ./update_table.sh $dbname
        ;;
    *)
        echo -e "\033[31mERROR: Wrong Answer, Please Enter a Number From 1 to 7\033[0m"
        ;;
    esac
done 

