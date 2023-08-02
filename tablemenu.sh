#! /usr/bin/bash

mkdir -p $HOME/DB
cd $HOME/DB/

echo "Hello SQL"
export PS3="SQLProj>>> "

function check_input_string {
    :
}

function create_table {
    :
}

function list_tables {
    :
}

function drop_table {
    :
}

function insert_into_table {
    :
}

function select_from_table {
    :
}

function delete_from_table {
    :
}

function update_table {
    :
}

select var in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table"
do
    case $REPLY in
    1)
        create_table
        ;;
    2)
        list_tables
        ;;
    3)
        drop_table
        ;;
    4)
        insert_into_table
        ;;
    5)
        select_from_table
        ;;
    6)
        delete_from_table
        ;;
    7)
        update_table
        ;;
    *)
        echo "Wrong Answer,Please Enter Number From 1 to 7"
        ;;
    esac
done
