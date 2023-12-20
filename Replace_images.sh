#!/bin/bash

ORIGINAL_FOLDER=${1}
DECODE_PATH=${2}
 
for i in "$ORIGINAL_FOLDER"/*.jpg; do
    if [ -f "$i" ] && [ ! -s "$i" ]; then
    
        FILENAME=$(basename "$i")
        CUT_ORIGINAL=$(echo "$FILENAME" | awk -F '_' '{print $2"_"$3}')
        MATCH_FILES=$(find "$DECODE_PATH" -type f -name "*${CUT_ORIGINAL}*")
 
        if [ -n "$MATCH_FILES" ]; the

            FIRST_MATCH_FILE=$(echo "$MATCH_FILES" | head -n 1)
            cp "$FIRST_MATCH_FILE" "$i"
            echo "$FILENAME: Replace completed"
        else
            echo "$FILENAME: No file in folder"
        fi
    fi
done
