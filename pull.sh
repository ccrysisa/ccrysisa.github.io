#!/bin/bash

git pull

if [[ "$#" -eq 1 && "$1" == "-t" ]]; then
    git submodule foreach git pull origin master
fi
