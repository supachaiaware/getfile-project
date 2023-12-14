#!/bin/bash


getMetaData(){

        #echo 'get image base 64, timestamp'

        TIMESTAMP=$(echo "${1}"| grep ^2023.*.idCardImage* | awk -F'|' '{print $1}' |tr -d ':')

        MOBILE_NUM=$(echo "${1}"| grep ^2023.*.idCardImage*  | awk -F'|' '{print $1 "|" $9}'|sed 's|"mobileNo":"|\||g'|sed  's/"mobileNo": "/|/g' |awk -F'|' '{print $NF}'|awk -F'"' '{print $1}')

        ID_CARD=$(echo "${1}" |grep ^2023.*.idCardImage*| awk -F'|' '{print $1 "|" $9}'|sed 's|"cardNo":"|\||g'|sed  's/"cardNo": "/|/g' |awk -F'|' '{print $NF}'|awk -F'"' '{print $1}')

        IMG_ENCODE=$(echo "${1}"| grep ^2023.*.idCardImage* | awk -F'|' '{print $1 "|" $9}'|sed 's|"idCardImage":"data:image/jpeg;base64,|\||g'|sed  's/"idCardImage": "/|/g'|sed 's/"idCardImage":"/|/g' |awk -F'|' '{print $NF}'|awk -F'"' '{print $1}')

        #echo "${TIMESTAMP}|${MOBILE_NUM}|${ID_CARD}|${IMG_ENCODE}"

}

fileCollector(){

        FOLDER_NAME=ImageDecode_$(ls -lrt ${1}/*.log |awk -F "_" '{print $NF}' |cut -d '.' -f1 |tail -1)

        if [ ! -d "${FOLDER_NAME}" ]; then

                mkdir -p "${FOLDER_NAME}"

        fi

                echo "get a file in path"

                if [ ! -d ${1} ];then

                echo "directory does not exist"
                fi

                        for ifile in $(ls ${1}/*.log);do

                                if [ -s "$ifile" ];then

                                        while  read iline ;do

                                              getMetaData "${iline}"

                                              IMAGE_NAME="${TIMESTAMP}_${MOBILE_NUM}_${ID_CARD}_pic.jpg"

                                        if [ ! -z ${IMG_ENCODE} ];then
                                              echo "convert file to: ${TIMESTAMP}_${MOBILE_NUM}_${ID_CARD}_pic.jpg"
                                              echo "${IMG_ENCODE}" | base64 -d > ${FOLDER_NAME}/${IMAGE_NAME}
                                        fi

                                        done < $ifile
                                else
                                        echo "$ifile is null"
                                fi
                        done

}

#### program start here

        if [ -z ${1} ];then
                echo "wrong args! Include directory"
                exit 127;
        fi

fileCollector ${1}
