#!/bin/bash

echo "Program Start ..."

GetIDcardImage() {

    grep ^2023.*.idCardImage* "${1}" | awk -F'|' '{print $1 "|" $9}' | sed 's/","/|/g; s/":"/|/g' | cut -d '|' -f1,7,49,57
}


DecodeBase64() {

  find "${1}" -type f -name "*.log" | while IFS= read -r i; do

        while IFS= read -r line; do


            TIMESTAMP=$(echo "$line" | cut -d '|' -f1 | tr -d ':')
            MOBILE_NUM=$(echo "$line" | cut -d '|' -f2)
            ID_CARD=$(echo "$line" | cut -d '|' -f3)

        FOLDER_NAME=$(ls "${1}" | awk -F'_' '{print $5}' | cut -d '.' -f1)

                if [ ! -d $FOLDER_NAME ];then
                        mkdir -p "$FOLDER_NAME"
                fi

            IMAGE_NAME="${TIMESTAMP}_${MOBILE_NUM}_${ID_CARD}_pic.jpg"

            echo "$line" | cut -d '|' -f4 | base64 -d > ${FOLDER_NAME}/${IMAGE_NAME}


            echo "Image name: ${TIMESTAMP}_${MOBILE_NUM}_${ID_CARD}_pic.jpg"

        done < <(GetIDcardImage "$i")

    done
}

DecodeBase64 "${1}"

echo "Program done and save image successfully."
