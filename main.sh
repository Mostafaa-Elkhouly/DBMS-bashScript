#! /usr/bin/bash

mkdir -p ./DB
#cd ./DB/

echo Hello SQL 
export PS3="SQLProj>>> "

select var in "List DBs" "Connect DB" "Create DB" "Rename DB" "Drop DB"
do

    case $REPLY in	
    1)
        ls -F ./DB/ | grep /
        ;;
    2)
        ./connect_db.sh
        ;;
    3)
        ./create_db.sh
        ;;
    4)
        ./rename_db.sh
        ;;
    5)
        ./drop_db.sh
        ;;
    *)
        echo "Wrong Entering!, Try Again ..."
        ;;
    esac
done 

