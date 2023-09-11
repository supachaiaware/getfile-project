#!/bin/bash

getKeyWord(){

    grep -i ^2023.*.X-Forwarded-For* ${1} |awk  -F'|' '{print $6"|"$11}' |cut -d',' -f1,8,9,10 |sed 's/{"key":"x-forwarded-for","value":"/|/g' |cut -d'|' -f1,3 |cut -d '"' -f1

}

getRePort_byFile(){

for i in $(find ${1}/ -type f -name "*.log");do

    getKeyWord $i >> tmp/tmp_$$_.out

done

}

echo "Start: $(date +'%Y%m%d %H:%M:%S')"

getRePort_byFile ${1}

sort tmp/tmp_$$_.out |uniq -c

echo "END: $(date +'%Y%m%d %H:%M:%S')"

rm -f tmp/tmp_$$_.out
