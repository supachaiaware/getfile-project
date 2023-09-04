#!/bin/bash

LOGS_PATH="${1}"

Transaction() {
  while read -r LINE; do
    SERVICE="$(echo "$LINE" | egrep -n "^\"2023|^2023|\}\|2023" | awk -F "|" '{print $6}')"
    CLIENT="$(echo "$LINE" | egrep -n "^\"2023|^2023|\}\|2023" | grep -o '"X-Forwarded-For":"[^"]\+"' | cut -d ":" -f 2-3 | tr -d '"')"

    if [ ! -z "${CLIENT}" ]; then
      echo "${CLIENT} | ${SERVICE} | ${DATE}"
    fi
  done < "$1"
}

######## Start ##########
DATE="$(ls "${LOGS_PATH}" | awk -F "_" '{print $4}' | tr -d '.log' | cut -c 1-8 |uniq)"
TIME="$(date "+%T")"
echo "Date: ${DATE} | Time: ${TIME}"
echo "---------------------------"

for ifile in "${LOGS_PATH}"/PSSBPROA902G_SSB-PROFILE-API_SUMMARY_*.log.gz; do
  Transaction "$ifile" | sort | uniq -c
done
