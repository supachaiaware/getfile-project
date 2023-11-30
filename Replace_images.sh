#!/bin/bash

ORIGINAL_FOLDER=${1}
DECODE_PATH=${2}

for i in "$ORIGINAL_FOLDER"/*; do
    if [ ! -s "$i" ]; then
        FILENAME=$(basename "$i")

        CUT_ORIGINAL=$(echo "$FILENAME" | awk -F '_' '{print $2"_"$3}')
        MACTH_FILE=$(find "$DECODE_PATH" -type f -name "*${CUT_ORIGINAL}*")

        if [ -n "$MACTH_FILE" ]; then
            cp "$MACTH_FILE" "$i"
            echo "$FILENAME: Replace completed"
        else
            echo "$FILENAME: No file in folder"
        fi
    fi
done
