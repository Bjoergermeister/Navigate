#!/bin/bash

database=~/.navigate.db

# Setup
function setupDatabase() {
    echo No database found, creating new database..
    sqlite3 $database "CREATE TABLE paths (name varchar, path varchar);"
    echo Done
}

# Functions for parameters
function add() {
    CheckForPathNameInDatabase $1

    if [ $? -eq 1 ]
    then
        echo "Path with name $1 already exists"
        return 0
    fi

    sqlite3 $database "INSERT INTO paths VALUES ('$1', '$2');"
}

function remove() {
    CheckForPathNameInDatabase $1
    if [ $? -eq 0 ]
    then
        return
    fi

    sqlite3 $database "DELETE FROM paths where name='$1';"
}

function list() {

    #Set delimeter
    IFS='|' 

    #Get number of database entries
    query=$(sqlite3 $database "SELECT COUNT(name) from paths";)

    if [ $query -eq 0 ] 
    then
        echo No entries
        return 1
    fi

    #Get entry, split parts and display in terminal
    for ((i = 0; i < $query; i++)); do
        read -a parts <<< $(sqlite3 $database "SELECT name,path FROM paths LIMIT 1 OFFSET $i;")
        echo "${parts[0]}": "${parts[1]}"        
    done
}

function navigate() {

    #Check if path with given name exists in database
    CheckForPathNameInDatabase $1
    if [ $? -eq 0 ]
    then 
        return 
    fi

    #Query path from database
    query=$(sqlite3 $database "SELECT path from paths where name='$1';")

    #Check if path exists in file systems
    CheckIfPathExists $query
    if [ $? -eq 0 ]
    then
        return
    fi

    #If all checks are ok, navigate to path
    cd "$query"
}

# Helper functions
function CheckForPathNameInDatabase() {
    query=$(sqlite3 $database "SELECT EXISTS(SELECT 1 FROM paths WHERE name='$1')")

    if [ $query -eq 0 ]
    then
        echo "No path with name $1"
        return 0
    fi

    return 0
}

function CheckIfPathExists() {
    if [ -d $1 ]
    then 
        echo Directory \"$1\" exists
        return 0
    else
        echo Directory \"$1\" doesn\'t exist
        return 1
    fi
}

#Setup database if it doesn't exist
if [[ ! -e ${database} ]]; then
    setupDatabase
fi

case $1 in 
"add")
    add "$2" "$3"
    ;;
"remove")
    remove $2
    ;;
"list")
    list
    ;;
"")
    echo No parameter provided
    ;;
*)
    navigate $1
    ;;
esac
