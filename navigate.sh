#! /bin/bash

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
    echo $1
}

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
