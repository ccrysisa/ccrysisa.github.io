#!/bin/bash

if [[ "$#" -eq 0 ]]; then
    hugo server
elif [[ "$#" -eq 1 && "$1" == "-d" ]]; then
    hugo server --disableFastRender --gc
fi
