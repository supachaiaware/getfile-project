#!/bin/bash

getKeyWord(){

    grep ^2023.*.X-Forwarded-For* ${1} |awk  -F'|' '{print $6"|"$17$18$19$20}'|sed 's/"X-Forwarded-For":"/|/g' |cut -d'|' -f1,3|cut -d'"' -f1

}

getRePort_byFile(){

for i in $(find ${1}/ -type f -name "*_$(date --date "1 day ago" +'%Y%m%d')*.log" );do

    getKeyWord $i >> tmp/tmp_$$_.out

done

}

echo "Start: $(date +'%Y%m%d %H:%M:%S')"

#Clear tmp file

getRePort_byFile ${1}

sort tmp/tmp_$$_.out |uniq -c

echo "END: $(date +'%Y%m%d %H:%M:%S')"

rm -f tmp/tmp_$$_.out
