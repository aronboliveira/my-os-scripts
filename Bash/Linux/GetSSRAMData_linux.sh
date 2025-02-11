#!/bin/bash
printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
"Fabricante" "Nome_da_Parte" "Serial" "Capacidade_(GB)" "Potencial_de_Velocidade_de_Relógio_(GHz)" \
"Velocidade_de_Relógio_em_Uso_(GHz)" "Versão_de_DDR" "Memória" "Localização" "Banco" \
"Largura_de_Dados_em_Barramento" "Voltagem_Configurada" "Voltagem_Mínima" "Voltagem_Máxima" \
"Removível" "Substituível"
sudo dmidecode -t memory | awk '
BEGIN {
    RS=""; FS="\n";
}
$0 ~ /Memory Device/ {
        if ($0 ~ /No Module Installed/) next;
    manuf = "Indefinido"; part = "Indefinido"; serial = "Indefinido";
    capacity = "Indefinido"; potentialSpeed = "Indefinido"; speed = "Indefinido";
    ddr = "Indefinido"; memDetail = "Indefinido";
    locator = "Indefinido"; bank = "Indefinido"; dataWidth = "Indefinido";
    voltConfigured = "Indefinido"; voltMin = "Indefinido"; voltMax = "Indefinido";
    removable = "Falso"; replaceable = "Indefinido";

    for(i=1;i<=NF;i++){
        if ($i ~ /Manufacturer:/) {
            sub(/.*Manufacturer:[ \t]*/, "", $i); manuf = $i;
        }
        if ($i ~ /Part Number:/) {
            sub(/.*Part Number:[ \t]*/, "", $i); part = $i;
        }
        if ($i ~ /Serial Number:/) {
            sub(/.*Serial Number:[ \t]*/, "", $i); serial = $i;
        }
        if ($i ~ /Size:/) {
            sub(/.*Size:[ \t]*/, "", $i);
                        if ($i ~ /No Module Installed/) next;
            sizeVal = $i;
            if ($i ~ /MB/) {
                gsub(/ MB.*/, "", sizeVal);
                capacity = sprintf("%.0f", sizeVal/1024);
            } else if ($i ~ /GB/) {
                gsub(/ GB.*/, "", sizeVal);
                capacity = sizeVal;
            }
        }
        if ($i ~ /Speed:/) {
            sub(/.*Speed:[ \t]*/, "", $i);
                        spd = $i; gsub(/ MT\/s.*/, "", spd);
            speed = sprintf("%.2f", spd/1000) " GHz";
        }
        if ($i ~ /^Type:/) {
                        sub(/.*Type:[ \t]*/, "", $i); ddr = $i;
        }
        if ($i ~ /Type Detail:/) {
            sub(/.*Type Detail:[ \t]*/, "", $i); memDetail = $i;
        }
        if ($i ~ /Locator:/) {
            sub(/.*Locator:[ \t]*/, "", $i); locator = $i;
        }
        if ($i ~ /Bank Locator:/) {
            sub(/.*Bank Locator:[ \t]*/, "", $i); bank = $i;
        }
        if ($i ~ /Data Width:/) {
            sub(/.*Data Width:[ \t]*/, "", $i); dataWidth = $i;
        }
        if ($i ~ /Configured Voltage:/) {
            sub(/.*Configured Voltage:[ \t]*/, "", $i); voltConfigured = $i;
        }
            }
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", \
        manuf, part, serial, capacity, potentialSpeed, speed, ddr, memDetail, locator, bank, \
        dataWidth, voltConfigured, voltMin, voltMax, removable, replaceable;
}'
