#!/bin/bash
echo "Starting to scan usb ports..."
echo "------------------------"
echo "USB PORT DATA (Linux)"
echo "------------------------"
printf "ID\tNome\tFabricante\tDescrição do Tipo\tProtocolo (USB Version)\tPNP ID\tStatus\n"

lspci -nn | grep -i "USB controller" | while read -r line; do
            id=$(echo "$line" | awk '{print $1}')
        descricao=$(echo "$line" | sed -e 's/.*USB controller: //I')
        fabricante=$(echo "$descricao" | awk '{print $1, $2}')
        nome=$(echo "$descricao" | cut -c1-50)
        protocolo="Indefinido"
        pnp="Indefinido"
        status="Operacional"

    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$id" "$nome" "$fabricante" "$descricao" "$protocolo" "$pnp" "$status"
done
read -p "Press Enter to exit"