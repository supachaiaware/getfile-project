#!/bin/bash
umask 000

getMetaData(){
    TIMESTAMP=$(echo "$1" | awk -F'|' '{print $1}' | tr -d ':')
    MOBILE_NUM=$(echo "$1" | awk -F'|' '{print $1 "|" $9}' | sed 's|"mobileNo":"|\||g' | sed  's/"mobileNo": "/|/g' | awk -F'|' '{print $NF}' | awk -F'"' '{print $1}')
    ID_CARD=$(echo "$1" | awk -F'|' '{print $1 "|" $9}' | sed 's|"cardNo":"|\||g' | sed  's/"cardNo": "/|/g' | awk -F'|' '{print $NF}' | awk -F'"' '{print $1}')
    IMG_ENCODE=$(echo "$1" | awk -F'|' '{print $1 "|" $9}' | sed 's|"idCardImage":"data:image/jpeg;base64,|\||g' | sed  's/"idCardImage": "/|/g' | sed 's/"idCardImage":"/|/g' | awk -F'|' '{print $NF}' | awk -F'"' '{print $1}')

}

fileCollector(){

        FOLDER_NAME=ImageDecode_$(ls -lrt ${1}/*.log.gz |awk -F "_" '{print $NF}' |cut -d '.' -f1 |tail -1)

        if [ ! -d "${FOLDER_NAME}" ]; then

                mkdir -p "${FOLDER_NAME}"

        fi


    if [ ! -d "${1}" ]; then
        echo "Directory does not exist: ${1}"
        exit 1
    fi

    for ifile in "${1}"/*.log.gz; do
        if [ -s "$ifile" ]; then
            zgrep '^2023.*.idCardImage*' "$ifile" | while read -r iline; do
                getMetaData "${iline}"
                IMAGE_NAME="${TIMESTAMP}_${MOBILE_NUM}_${ID_CARD}_pic.jpg"
                if [ ! -z ${IMG_ENCODE} ];then
                    echo "convert file to: ${TIMESTAMP}_${MOBILE_NUM}_${ID_CARD}_pic.jpg"
                    echo "${IMG_ENCODE}" | base64 -d > ${FOLDER_NAME}/${IMAGE_NAME}
                fi
            done
        else
            echo "$ifile is empty or does not exist"
        fi
    done
}

#### Program starts here

if [ -z "${1}" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

fileCollector "${1}"
