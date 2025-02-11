#!/bin/bash

echo "------------------------"
echo "VIDEO CONTROLLERS (macOS)"
echo "------------------------"
printf "ID\tNome\tMemória Dedicada (GB)\tDAC do Adaptador\tDisponibilidade\tBits por Pixel\tResolução Horizontal\tResolução Vertical\tNúmero total de Cores\tTaxa de Atualização Mínima (Hz)\tTaxa de Atualização Máxima (Hz)\tModo de Scan\tTipo de Dither\tVersão do Driver\tData do Driver\tSeção de Informação\tArquivo de Informação\tCaminho para os Drivers\tIdentificador PNP\tArquitetura de Vídeo\tTipo de Memória\tStatus\n"

system_profiler SPDisplaysDataType | awk -F": " '
/^[ \t]*Chipset Model:/ { model = $2 }
/^[ \t]*Device ID:/ { id = $2 }
/^[ \t]*VRAM/ {
        split($2, a, " ");
    vram = a[1];
    mem = sprintf("%.2f", vram/1024); }
/^[ \t]*EFI Driver Version:/ { driverVer = $2 }
/^[ \t]*Bus:/ { bus = $2 }
END {
    if (id == "") id = "Indefinido";
    if (model == "") model = "Indefinido";
    if (mem == "") mem = "Indefinido";
    if (driverVer == "") driverVer = "Indefinido";
    if (bus == "") bus = "Indefinido";
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
    driverDate = "Indefinido";
    infSection = "Indefinido";
    infFile = "Indefinido";
    driverPath = "Indefinido";
    pnp = "Indefinido";
    memType = "Indefinido";
    status = "Operacional";
        videoArch = bus;
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", \
        id, model, mem, dac, availability, bpp, resH, resV, cores, minRefresh, maxRefresh, scanMode, dither, driverVer, driverDate, infSection, infFile, driverPath, pnp, videoArch, memType, status;
}'
