#!/bin/bash

getKeyWord(){

    zgrep '^2023\|^2024.*.X-Forwarded-For*' ${1}|awk  -F'|' '{print $3"|"$16,$17,$18,$19,$20}'|sed 's/"X-Forwarded-For":"/|/g' |cut -d '|' -f1,3|cut -d'"' -f1

}

getRePort_byFile(){

    for i in $(find ${1}/ -type f -name "*.log.gz" );do

    getKeyWord $i >> tmp/tmp_$$_.out

    done

}

        echo "Start: $(date +'%Y%m%d %H:%M:%S')"

getRePort_byFile ${1}

    sort tmp/tmp_$$_.out |uniq -c

        echo "END: $(date +'%Y%m%d %H:%M:%S')"

    rm -f tmp/tmp_$$_.out
