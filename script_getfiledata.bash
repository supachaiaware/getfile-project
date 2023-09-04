#!/bin/bash

LOGS_PATH="${1}"

Transaction() {
 zcat $1| while read -r LINE; do
    SERVICE="$(echo "$LINE" | egrep -n "^\"2023|^2023|\}\|2023" | awk -F "|" '{print $6}')"

    CLIENT="$(echo "$LINE" | egrep -n "^\"2023|^2023|\}\|2023" | grep -o '"X-Forwarded-For":"[^"]\+"' | cut -d ":" -f 2-3 | tr -d '"')"

    if [ ! -z "${CLIENT}" ]; then
      echo "${CLIENT} | ${SERVICE} | ${DATE}"
    fi

  done 
}

######## Start ##########

DATE=$(date --date "1 day ago" +'%Y%m%d' )
TIME="$(date "+%T")"
echo "Date: ${DATE} | Time: ${TIME}"
echo "---------------------------"

PATH_LIST="/NAS/TLS/VAS_SSB_TRANSFORM/PSSBPKGA801G/SSB-PACKAGE-API/log/detail
/NAS/TLS/VAS_SSB_TRANSFORM/PSSBPROA801G/SSB-PROFILE-API/log/detail
/NAS/TLS/VAS_SSB_TRANSFORM/PSSBSRVA801G/SSB-SERVICE-API/log/detail
/NAS/SUK/SSB_OLYMPUS/PSSBOPB201G/apipackage/log/detail
/VASQUERY/API_TRANSFORM/PAPITRNA801G/API-TRANSFORM/detail"

for ifile in "${PATH_LIST}/$(date --date "1 day ago" +'%Y%m%d' )"; do 
    for i in $(find  $ifile/ -type f -name "*.gz"); do
        if [ -f "$i" ];then Transaction "$i"; fi
    done
done | sort | uniq -c
