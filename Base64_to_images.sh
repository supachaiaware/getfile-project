#!/bin/bash

getKeyWord() {
    grep ^2023.*.idCardImage* "${1}" | awk -F'|' '{print $1 "|" $9}' | sed 's/","/|/g; s/":"/|/g' | cut -d '|' -f1,7,49,57
}

getRePort_byFile() {
    for i in $(find "${1}" -type f -name "*.log"); do
        getKeyWord "$i" >> tmp/tmp_$$_.out
    done
}

getRePort_byFile "${1}"

sort tmp/tmp_$$_.out

# Base64
counter=1

while IFS= read -r line; do
    TIMESTAMP=$(echo "$line" | cut -d '|' -f1 | tr -d ':')
    MOBILE_NUM=$(echo "$line" | cut -d '|' -f2)
    ID_CARD=$(echo "$line" | cut -d '|' -f3)

Image_file="tmp/${TIMESTAMP}_${MOBILE_NUM}_${ID_CARD}_pic.jpg"

    echo "$line" | cut -d '|' -f4  | base64 -d > "$Image_file"
    ((counter++))
done < tmp/tmp_$$_.out

