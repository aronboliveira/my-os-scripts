#!/bin/bash
printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
"Fabricante" "Nome_da_Parte" "Serial" "Capacidade_(GB)" "Potencial_de_Velocidade_de_Relógio_(GHz)" \
"Velocidade_de_Relógio_em_Uso_(GHz)" "Versão_de_DDR" "Memória" "Localização" "Banco" \
"Largura_de_Dados_em_Barramento" "Voltagem_Configurada" "Voltagem_Mínima" "Voltagem_Máxima" \
"Removível" "Substituível"
system_profiler SPMemoryDataType | awk '
BEGIN {
    RS = "\n\n";
    FS = "\n";
}
$1 ~ /BANK/ {
        slot = $1; gsub(":", "", slot);
        manuf = "Indefinido";
    part = "Indefinido";
    serial = "Indefinido";
    capacity = "Indefinido";
    potentialSpeed = "Indefinido";
    usedSpeed = "Indefinido";
    ddr = "Indefinido";
    memDetail = "Indefinido";
    locator = slot;
    bank = slot;
    dataWidth = "Indefinido";
    voltConfigured = "Indefinido";
    voltMin = "Indefinido";
    voltMax = "Indefinido";
    removable = "Indefinido";
    replaceable = "Indefinido";

    for (i = 1; i <= NF; i++) {
        if ($i ~ /Size:/) {
            sub(/.*Size:[ \t]*/, "", $i);
                        sizeVal = $i;
            gsub(/ GB.*/, "", sizeVal);
            capacity = sizeVal;
        }
        if ($i ~ /Speed:/) {
            sub(/.*Speed:[ \t]*/, "", $i);
                        if ($i ~ /MHz/) {
                split($i, a, " ");
                usedSpeed = sprintf("%.2f", a[1]/1000) " GHz";
            } else {
                usedSpeed = $i;
            }
        }
        if ($i ~ /Type:/) {
            sub(/.*Type:[ \t]*/, "", $i);
            ddr = $i;
        }
    }
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", \
        manuf, part, serial, capacity, potentialSpeed, usedSpeed, ddr, memDetail, locator, bank, \
        dataWidth, voltConfigured, voltMin, voltMax, removable, replaceable;
}'
