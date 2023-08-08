#! /usr/bin/bash

dbname=$1
cd "./DB/$dbname/"

read -r -p "Enter Table Name To Be Deleted: " tablename
if [ -f $tablename ]
then 
	read -r -p "Are You Sure You Want To Delete $tablename Table ? (Y/N) : " choice
	case $choice in
		[yY]*) 
			rm $tablename 
			echo "Table Deleted Successfully" 
			;;

		[nN]*) 
			echo "Canceled"
			;;

		*) 
			echo -e "\033[31mERROR: Invalid Option\033[0m"
			;;
	esac
else
	echo -e "\033[31mERROR: $name Table Not Exist\033[0m"
fi



		
