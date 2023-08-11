#! /usr/bin/bash

dbname=$1
cd "./DB/$dbname/"
export PS3="$dbname:dropTable> "

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
			echo -e "\e[31mERROR: Invalid Option\e[0m"
			;;
	esac
else
	echo -e "\e[31mERROR: $name Table Not Exist\e[0m"
fi



		
