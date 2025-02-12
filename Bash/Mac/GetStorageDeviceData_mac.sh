#!/bin/bash
echo "Starting to scan storage devices..."
echo "------------------------"
echo "VOLUMES"
echo "------------------------"
printf "ID do Volume\tRótulo\tNome\tDrive\tTipo de Drive\tSistema de Arquivos\tArmazenamento Total (GB)\tArmazenamento Restante (GB)\tOperabilidade\tDeduplicação\n"
df -k | tail -n +2 | while read filesystem size used avail percent mount; do
        id=$(diskutil info "$filesystem" 2>/dev/null | awk -F: '/Volume UUID/ {print $2}' | xargs)
    [ -z "$id" ] && id="$filesystem"
    label=$(diskutil info "$filesystem" 2>/dev/null | awk -F: '/Volume Name/ {print $2}' | xargs)
    [ -z "$label" ] && label="Nulo"
    nome="$mount"
    drive="$filesystem"
    tipoDrive=$(diskutil info "$filesystem" 2>/dev/null | awk -F: '/Device / {print $2}' | xargs)
    [ -z "$tipoDrive" ] && tipoDrive="Nulo"
    fs=$(diskutil info "$filesystem" 2>/dev/null | awk -F: '/Type \(Bundle\)/ {print $2}' | xargs)
    [ -z "$fs" ] && fs="Nulo"
        totalGB=$(awk -v kb="$size" 'BEGIN {printf "%.2f", kb/1048576}')
    availGB=$(awk -v kb="$avail" 'BEGIN {printf "%.2f", kb/1048576}')
    operabilidade="Operacional"
    dedup="Nulo"
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$id" "$label" "$nome" "$drive" "$tipoDrive" "$fs" "$totalGB" "$availGB" "$operabilidade" "$dedup"
done

echo -e "\n------------------------"
echo "PHYSICAL DISKS"
echo "------------------------"
printf "ID\tNome\tSerial\tMedia\tBarramento\tAdicionável em Pool\n"
diskutil list | grep "^/dev/disk" | awk '{print $1}' | while read disk; do
    model=$(diskutil info "$disk" | awk -F: '/Device / {print $2}' | xargs)
    [ -z "$model" ] && model="Nulo"
    serial="Nulo"       media=$(diskutil info "$disk" | awk -F: '/Media Name/ {print $2}' | xargs)
    [ -z "$media" ] && media="Nulo"
    barramento="Nulo"      pool="Nulo"
    printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$disk" "$model" "$serial" "$media" "$barramento" "$pool"
done

echo -e "\n------------------------"
echo "DISK DRIVES"
echo "------------------------"
printf "ID\tModelo\tPartições\tTamanho (GB)\tInterface\tMedia\n"
diskutil list | grep "^/dev/disk" | awk '{print $1}' | while read disk; do
    model=$(diskutil info "$disk" | awk -F: '/Device / {print $2}' | xargs)
    [ -z "$model" ] && model="Nulo"
    partitions=$(diskutil list "$disk" | grep "^   " | wc -l)
    sizeStr=$(diskutil info "$disk" | awk -F: '/Total Size/ {print $2}' | xargs)
        totalSize=$(echo "$sizeStr" | awk '{print $1}')
    interface="Nulo"       media="Nulo"           printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$disk" "$model" "$partitions" "$totalSize" "$interface" "$media"
done
read -p "Press Enter to exit"