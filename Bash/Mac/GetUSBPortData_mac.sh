#!/bin/bash
echo "Starting to scan usb ports..."
echo "------------------------"
echo "USB PORT DATA (macOS)"
echo "------------------------"
printf "ID\tNome\tFabricante\tDescrição do Tipo\tProtocolo (USB Version)\tPNP ID\tStatus\n"

system_profiler SPUSBDataType | awk -F": " '
/Host Controller Location/ {
        id = "Nulo";
        nome = $2;
        fabricante = "Indefinido";
        descricao = "Host Controller at " $2;
        protocolo = "Indefinido";
        pnp = "Indefinido";
        status = "Operacional";
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", id, nome, fabricante, descricao, protocolo, pnp, status;
}
'
read -p "Press Enter to exit"