#!/bin/bash

git add .

if [[ "$#" -eq 0 ]]; then
    git commit -m "update $(date)"
elif [[ "$#" -eq 1 && "$1" == "-a" ]]; then
    git commit --amend
fi
