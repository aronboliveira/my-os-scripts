#!/bin/bash
echo "Starting to scan video controller..."
echo "------------------------"
echo "VIDEO CONTROLLERS (Linux)"
echo "------------------------"
printf "ID\tNome\tMemória Dedicada (GB)\tDAC do Adaptador\tDisponibilidade\tBits por Pixel\tResolução Horizontal\tResolução Vertical\tNúmero total de Cores\tTaxa de Atualização Mínima (Hz)\tTaxa de Atualização Máxima (Hz)\tModo de Scan\tTipo de Dither\tVersão do Driver\tData do Driver\tSeção de Informação\tArquivo de Informação\tCaminho para os Drivers\tIdentificador PNP\tArquitetura de Vídeo\tTipo de Memória\tStatus\n"
lspci -v -d ::0300 | awk '
BEGIN {
        dedicatedMem = "Indefinido";
    dac = "Indefinido";
    availability = "Operacional";
    bpp = "Indefinido";
    resH = "Indefinido";
    resV = "Indefinido";
    cores = "Indefinido";
    minRefresh = "Indefinido";
    maxRefresh = "Indefinido";
    scanMode = "Indefinido";
    dither = "Indefinido";
    driverVersion = "Indefinido";
    driverDate = "Indefinido";
    infSection = "Indefinido";
    infFile = "Indefinido";
    driverPath = "Indefinido";
    pnp = "Indefinido";
    memType = "Indefinido";
    status = "Operacional";
}
$0 ~ /VGA compatible controller/ {
        id = $1;
        sub(/:$/, "", id);
        desc = $0; sub(/^[^:]+: /, "", desc);
    name = desc;
        if (desc ~ /Intel/) videoArch = "Intel";
    else if (desc ~ /NVIDIA/) videoArch = "NVIDIA";
    else if (desc ~ /AMD/ || desc ~ /ATI/) videoArch = "AMD";
    else videoArch = "Indefinido";
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", \
        id, name, dedicatedMem, dac, availability, bpp, resH, resV, cores, minRefresh, maxRefresh, scanMode, dither, driverVersion, driverDate, infSection, infFile, driverPath, pnp, videoArch, memType, status;
}
'
read -p "Press Enter to exit"