#! /usr/bin/env bash

database="navigate.sqlite"

function setupDatabase() {
    sqlite3 $database "CREATE TABLE paths (name varchar, path varchar);"
}

function add() {
    sqlite3 $database "INSERT INTO paths VALUES ('$1', '$2');"
}

function remove() {
    sqlite3 $database "DELETE FROM paths where name='$1';"
}

function list() {
    echo List
}

function navigate() {
    query=$(sqlite3 navigate.sqlite "SELECT path from paths where name='$1';")
    echo $query
}

#Setup database if it doesn't exist
if [[ ! -e ${database} ]]; then
    echo Database file doesnt exist
    setupDatabase
fi

case $1 in 
"add")
    add $2 $3
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
