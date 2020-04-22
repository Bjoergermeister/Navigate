#! /usr/bin/env bash

database="navigate.sqlite"

function setupDatabase() {
    echo No database found, creating new database..
    sqlite3 $database "CREATE TABLE paths (name varchar, path varchar);"
    echo Done
}

function add() {
    sqlite3 $database "INSERT INTO paths VALUES ('$1', '$2');"
}

function remove() {
    sqlite3 $database "DELETE FROM paths where name='$1';"
}

function list() {
    query=$(sqlite3 $database "SELECT COUNT(name) from paths";)

    for ((i = 0; i < $query; i++)); do
        row=$(sqlite3 $database "SELECT * FROM paths LIMIT 1 OFFSET $i;")
        echo $row
    done
}

function navigate() {
    query=$(sqlite3 navigate.sqlite "SELECT path from paths where name='$1';")
    cd $query
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
