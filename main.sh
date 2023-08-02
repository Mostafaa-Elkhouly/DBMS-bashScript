#! /usr/bin/bash

mkdir -p $HOME/DB
cd $HOME/DB/

echo Hello SQL 
export PS3="SQLProj>>> "


function connect_db {
	read -p "Enter DB Name: " name
	if [[ -d $name && -e $name ]] ; then
		cd ./$name
		pwd
		#menu tables file --> export PS3="$name> "
	else
		echo ERROR: DB Not Found! 
	fi
}

function create_db {

        read -p "Enter DB Name: " name
        if [[ -e $name ]] ; then
                echo ERROR: DB Exist!
        else
                mkdir $name 
        fi
}

function rename_db {

        read -p "Enter DB Name: " name
        if [[ -d $name && -e $name ]] ; then
                read -p "Enter DB New Name: " new_name
		mv $name $new_name
        else
		echo ERROR: DB Not Found!                  
        fi
}

function drop_db {

        read -p "Enter DB Name: " name
        if [[ -d $name  && -e $name ]] ; then
                rm -r $name
        else
                echo ERROR: DB Not Found
        fi
}


select var in "List DBs" "Connect DB" "Create DB" "Rename DB" "Drop DB"
do

    case $REPLY in	
    1)
	    ls -F | grep /
	    ;;
    2)
	    connect_db
	    ;;
    3)
	    create_db
	    ;;
    4)
	    rename_db
	    ;;
    5)
	    drop_db
	    ;;
    *)
            echo "Wrong Entering!, Try Again ..."
	    ;;
    esac
done 
