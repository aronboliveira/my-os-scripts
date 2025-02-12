#!/bin/bash
echo "Starting to scan storage devices..."
echo "------------------------"
echo "VOLUMES"
echo "------------------------"
printf "ID do Volume\tRótulo\tNome\tDrive\tTipo de Drive\tSistema de Arquivos\tArmazenamento Total (GB)\tArmazenamento Restante (GB)\tOperabilidade\tDeduplicação\n"

df -k --output=source,target,size,avail,fstype | tail -n +2 | while read source mount size avail fstype; do
        label=$(blkid -o value -s LABEL "$source" 2>/dev/null)
    [ -z "$label" ] && label="Nulo"
    nome="$mount"
    drive="$source"
        tipoDrive=$(lsblk -no TYPE "$source" 2>/dev/null)
    [ -z "$tipoDrive" ] && tipoDrive="Nulo"
        fs="$fstype"
    [ -z "$fs" ] && fs="Nulo"
        totalGB=$(awk -v kb="$size" 'BEGIN {printf "%.2f", kb/1048576}')
    availGB=$(awk -v kb="$avail" 'BEGIN {printf "%.2f", kb/1048576}')
    operabilidade="Operacional"      dedup="Nulo"
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$source" "$label" "$nome" "$drive" "$tipoDrive" "$fs" "$totalGB" "$availGB" "$operabilidade" "$dedup"
done

echo -e "\n------------------------"
echo "PHYSICAL DISKS"
echo "------------------------"
printf "ID\tNome\tSerial\tMedia\tBarramento\tAdicionável em Pool\n"
lsblk -d -o NAME,MODEL,SERIAL,TYPE,TRAN | tail -n +2 | while read id model serial type tran; do
    [ -z "$model" ] && model="Nulo"
    [ -z "$serial" ] && serial="Nulo"
    [ -z "$tran" ] && tran="Nulo"
    pool="Nulo"
    printf "/dev/%s\t%s\t%s\t%s\t%s\t%s\n" "$id" "$model" "$serial" "$type" "$tran" "$pool"
done

echo -e "\n------------------------"
echo "DISK DRIVES"
echo "------------------------"
printf "ID\tModelo\tPartições\tTamanho (GB)\tInterface\tMedia\n"
lsblk -d -o NAME,MODEL,SIZE,ROTA,TRAN | tail -n +2 | while read id model size rota tran; do
    partitions=$(lsblk "/dev/$id" -n | wc -l)
    interface=${tran:-"Nulo"}
        if [ "$rota" -eq 1 ]; then 
        media="Fixed hard disk media"
    else 
        media="External hard disk media"
    fi
    printf "/dev/%s\t%s\t%s\t%s\t%s\t%s\n" "$id" "$model" "$partitions" "$size" "$interface" "$media"
done
read -p "Press Enter to exit"