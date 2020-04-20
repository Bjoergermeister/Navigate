#! /usr/bin/env bash

database="navigate.sqlite"

function setupDatabase() {
    sqlite3 $database "CREATE TABLE paths (name varchar, path varchar);"
}

function add() {
    echo Add
}

function remove() {
    echo Remove
}

function list() {
    echo List
}

function navigate() {
    #query=$(sqlite3 navigate.sqlite "SELECT path from paths where name='$1';")
    echo $1
}

#Setup database if it doesn't exist
if [[ ! -e ${database} ]]; then
    echo Database file doesnt exist
    setupDatabase
fi

case $1 in 
"add")
    add
    ;;
"remove")
    remove
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
