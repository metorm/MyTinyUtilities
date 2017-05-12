#!/bin/bash
# Delete .eval file from all crossover containers

crs_root=$HOME/.cxoffice

echo "Working on $crs_root"

for file in $crs_root/*
do
    if test -d $file
    then
        if [ -f $file/.eval ]; then
            echo "Delete: $file/.eval"
            rm $file/.eval
        fi
    fi
done
