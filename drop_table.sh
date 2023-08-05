#! /usr/bin/bash

dbname=$1
cd "./DB/$dbname/"

read -p "Enter Table Name To Be Deleted: " tablename
if [ -f $tablename ]
then 
	read -p "Are You Sure You Want To Delete $tablename Table ? (Y/N) : " choice
	case $choice in
		[yY]*) 
			rm $tablename 
			echo "Table Deleted Successfully" 
			;;

		[nN]*) 
			echo "Canceled"
			;;

		*) 
			echo "Invalid Option"
			;;
	esac
else
	echo "$name Table Not Exist"
fi



		
