#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
    STAT_CMD='stat -f %z'
else
    STAT_CMD='stat -c%s'
fi

startDir="${1:-/}"
tempFile=$(mktemp)  counter=0

find "$startDir" -type f -print0 2>/dev/null | while IFS= read -r -d '' file; do
    filesize=$($STAT_CMD "$file" 2>/dev/null)
    [ -z "$filesize" ] && continue
    currentFolder=$(dirname "$file")

        while [ -n "$currentFolder" ]; do
        echo "$currentFolder $filesize" >> "$tempFile"
        parentFolder=$(dirname "$currentFolder")
        [ "$currentFolder" = "$parentFolder" ] && break
        currentFolder="$parentFolder"
    done
    echo "/ $filesize" >> "$tempFile"

    ((counter++))
    if (( counter % 1000 == 0 )); then
        echo "Scanned $counter files... Current file: $file"
    fi
done

echo -e "\nCOMPLETE: Processed $counter files total.\n"

awk '{ sizes[$1] += $2 } END { for (dir in sizes) print dir, sizes[dir] }' "$tempFile" |
    sort -k2 -nr | head -n 200 | while read -r folder size; do
        totalSizeGB=$(awk -v bytes="$size" 'BEGIN {printf "%.2f", bytes/1073741824}')
        totalSizeMB=$(awk -v bytes="$size" 'BEGIN {printf "%.2f", bytes/1048576}')
        fileCount=$(find "$folder" -type f 2>/dev/null | wc -l)
        printf "FolderPath: %s, TotalSizeGB: %s, TotalSizeMB: %s, FileCount: %s\n" \
            "$folder" "$totalSizeGB" "$totalSizeMB" "$fileCount"
    done

rm "$tempFile"  