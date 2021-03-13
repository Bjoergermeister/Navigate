#!/bin/bash

database="navigate.sqlite"

# Setup
function setupDatabase() {
    echo No database found, creating new database..
    sqlite3 $database "CREATE TABLE paths (name varchar, path varchar);"
    echo Done
}

# Functions for parameters
function add() {
    sqlite3 $database "INSERT INTO paths VALUES ('$1', '$2');"
}

function remove() {
    sqlite3 $database "DELETE FROM paths where name='$1';"
}

function list() {

    #Set delimeter
    IFS='|' 

    #Get number of database entries
    query=$(sqlite3 $database "SELECT COUNT(name) from paths";)

    #Get entry, split parts and display in terminal
    for ((i = 0; i < $query; i++)); do
        read -a parts <<< $(sqlite3 $database "SELECT name,path FROM paths LIMIT 1 OFFSET $i;")
        echo "${parts[0]}": "${parts[1]}"        
    done
}

function navigate() {

    #Check if paths exist in database
    CheckForPathInDatabase $1
    if [ $? -eq 1 ]
    then 
        #If so, navigate to it
        navigate $1
    else
        echo Path \"$1\" doesn\'t exists!
    fi 

    query=$(sqlite3 navigate.sqlite "SELECT path from paths where name='$1';")
    cd "$query"
}

# Helper functiosn
function CheckForPathInDatabase() {
    subquery="SELECT name FROM paths WHERE name='$1'"
    query=$(sqlite3 $database "SELECT EXISTS($subquery) from paths";)

    return $query
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
