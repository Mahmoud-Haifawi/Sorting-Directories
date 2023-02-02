#!/bin/bash

#This function checks the number of arguments:

function countArg () {
    if [ $# -ne 3 ]; then
     echo -e "This script requires 3 arguments, and you passed $# arguments!\n\n"
     echo -e "Explanation:\n"
     echo -e "$(readlink -f $0) argument1 argument2 argument3\n"
     echo -e "argument1 must be the directory that you want to process\n"
     echo -e "argument2 must be one of the following:"
     echo -e "1. ana\n2. del\n3. arr\n\n"
     echo -e "If \"ana\" is argument2, argument3 must be a regex that you want to use to list all the files whose names match it.\n"
     echo -e "If \"del\" is argument2, argument3 must be a size followed by the size in KB (enter the size in numbers only), and the script will delete the files larger than that size.\n"
     echo -e "If \"arr\" is argument2, argument3 must be a file extension (without the dot), and the script will move all the files from that type within that directory to a new sub-directory named by that extension."
     exit 1
    fi
}


#This function checks if the first argument is really a directory or not:

function isDir () {
   if [ ! -d "$1" ]; then
    echo "The first argument must be an existing and a valid directory!"
    exit 1
   fi
}


#This function calls the appropriate function based on the value of the second argument:

function checkArg () {
   if [ "$2" == "ana" ]; then
      ana "$@"
      
   elif [ "$2" == "del" ]; then
      del "$@"
      
   elif [ "$2" == "arr" ]; then
      arr "$@"
      
   else 
      echo "$2 is an invalid option, the available options are \"ana\", \"del\" or \"arr\""
      exit 1
   fi
}


#ana (the analytics function):

function ana () {
   echo "There are $(find $1 -regex $3 |wc -l) files/directories that match the regex that you entered."
   find $1 -regex $3
}


#del (the deletion function):

function del () {
   echo "The following files will be deleted:"
   find $1 -type f -size +$3k
   
   find $1 -type f -size +$3k -delete
}


#arr (the arrangement function):

function arr () {
   if [ ! -d "$1/$3" ]; then
     mkdir $3
   fi
   
   find $1 -maxdepth 1 -name "*.$3" -exec mv {} $1/$3 \;  
}


countArg "$@"
isDir "$1"
checkArg "$@"
