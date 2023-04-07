#!/bin/bash

for f in $(find . -name update.sh)
do
    echo ---------------
    echo $f
    eval $f
    [[ "$?" == 0 ]] && echo OK $f || echo Error $f
    echo ---------------
done
