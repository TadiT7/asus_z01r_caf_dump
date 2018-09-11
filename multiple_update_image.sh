#!/bin/bash

declare -a SSN
SSN=(`sudo ./fastboot devices | awk 'BEGIN {count=0;} {name[count] = $1;count++;}; END{for (i=0;i<NR;i++) print name[i]}'`)
for((i=0;i<${#SSN[@]};i++))
do
    echo "flash ${SSN[i]} device"
    if [ "$1" != "" ]; then
        ./update_image.sh $1 ${SSN[i]}
    else
        ./update_image.sh ${SSN[i]}
    fi
done
