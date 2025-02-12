#!/bin/bash
echo "Starting to scan folders..."
startDir="${1:-/}"
declare -A folderSizes
counter=0
while IFS= read -r -d '' file; do
    filesize=$(stat -c%s "$file" 2>/dev/null)
        [ -z "$filesize" ] && continue
    currentFolder=$(dirname "$file")
        while [ -n "$currentFolder" ]; do
                folderSizes["$currentFolder"]=$(( ${folderSizes["$currentFolder"]:-0} + filesize ))
        parentFolder=$(dirname "$currentFolder")
                if [ "$currentFolder" = "$parentFolder" ]; then
            break
        fi
        currentFolder="$parentFolder"
    done
        folderSizes["/"]=$(( ${folderSizes["/"]:-0} + filesize ))
    ((counter++))
    if (( counter % 1000 == 0 )); then
        echo "Scanned $counter files... Current file: $file"
    fi
done < <(find "$startDir" -type f -print0 2>/dev/null)
echo -e "\nCOMPLETE: Processed $counter files total.\n"
{
  for folder in "${!folderSizes[@]}"; do
      echo -e "$folder\t${folderSizes[$folder]}"
  done
} | sort -k2 -nr | head -n 200 | while IFS=$'\t' read -r folder size; do
        totalSizeGB=$(awk -v bytes="$size" 'BEGIN {printf "%.2f", bytes/1073741824}')
    totalSizeMB=$(awk -v bytes="$size" 'BEGIN {printf "%.2f", bytes/1048576}')
        fileCount=$(find "$folder" -type f 2>/dev/null | wc -l)
    printf "FolderPath: %s, TotalSizeGB: %s, TotalSizeMB: %s, FileCount: %s\n" "$folder" "$totalSizeGB" "$totalSizeMB" "$fileCount"
done
read -p "Press Enter to exit"