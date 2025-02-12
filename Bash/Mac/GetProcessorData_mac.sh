#!/bin/bash
echo "Starting to scan processor..."
read -p "Press Enter to exit"
ID="Indefinido"
ID_Processador="Indefinido"
Numero_Serie="Indefinido"  
Nome=$(sysctl -n machdep.cpu.brand_string)
Legenda="$Nome"
Fabricante=$(sysctl -n machdep.cpu.vendor)
Tipo="Indefinido"       Nucleos_Fisicos=$(sysctl -n machdep.cpu.core_count)
Nucleos_Ativos="$Nucleos_Fisicos"
Processos_Logicos=$(sysctl -n machdep.cpu.thread_count)
Soquete="Indefinido"    Funcao="Indefinido"
Familia="Indefinido"    Arquitetura=$(uname -m)
Nivel="Indefinido"
PartNumber="Indefinido"

Características=$(sysctl -n machdep.cpu.features)
Descricao="Indefinido"

freq_hz=$(sysctl -n hw.cpufrequency 2>/dev/null)
if [[ -n "$freq_hz" ]]; then
  Clock_Atual_GHz=$(awk "BEGIN {printf \"%.2f\", $freq_hz/1000000000}")
else
  Clock_Atual_GHz="Indefinido"
fi
Clock_Maximo_GHz="Indefinido"  Clock_Externo_MHz="Indefinido"

Cache_L2_raw=$(sysctl -n hw.l2cachesize 2>/dev/null)
if [[ -n "$Cache_L2_raw" ]]; then
  Cache_L2_MB=$(awk "BEGIN {printf \"%.1f\", $Cache_L2_raw/1024/1024}")
else
  Cache_L2_MB="Indefinido"
fi
Cache_L3_raw=$(sysctl -n hw.l3cachesize 2>/dev/null)
if [[ -n "$Cache_L3_raw" ]]; then
  Cache_L3_MB=$(awk "BEGIN {printf \"%.1f\", $Cache_L3_raw/1024/1024}")
else
  Cache_L3_MB="Indefinido"
fi
Vel_Cache_L2_GHz="Indefinido"
Vel_Cache_L3_GHz="Indefinido"

Threads=$(sysctl -n machdep.cpu.thread_count)
Voltagem_Atual="Indefinido"
Voltagens_Suportadas="Indefinido"
if sysctl -n machdep.cpu.features | grep -E -qw "VMX"; then
  Virtualizacao_Ativa="Sim"
else
  Virtualizacao_Ativa="Não"
fi
ID_PNP="Indefinido"
Largura_Endereco=$(getconf LONG_BIT)
Largura_Dados=$(getconf LONG_BIT)
Estado="Indefinido"
Disponibilidade="Indefinido"
Status="Indefinido"
Info_Status="Indefinido"

printf "%-25s: %s\n" "ID" "$ID"
printf "%-25s: %s\n" "ID do Processador" "$ID_Processador"
printf "%-25s: %s\n" "Número de Série" "$Numero_Serie"
printf "%-25s: %s\n" "Nome" "$Nome"
printf "%-25s: %s\n" "Legenda" "$Legenda"
printf "%-25s: %s\n" "Fabricante" "$Fabricante"
printf "%-25s: %s\n" "Tipo" "$Tipo"
printf "%-25s: %s\n" "Núcleos Físicos" "$Nucleos_Fisicos"
printf "%-25s: %s\n" "Núcleos Ativos" "$Nucleos_Ativos"
printf "%-25s: %s\n" "Processos Lógicos" "$Processos_Logicos"
printf "%-25s: %s\n" "Soquete" "$Soquete"
printf "%-25s: %s\n" "Função" "$Funcao"
printf "%-25s: %s\n" "Família" "$Familia"
printf "%-25s: %s\n" "Arquitetura" "$Arquitetura"
printf "%-25s: %s\n" "Nível" "$Nivel"
printf "%-25s: %s\n" "PartNumber" "$PartNumber"
printf "%-25s: %s\n" "Características" "$Características"
printf "%-25s: %s\n" "Descrição" "$Descricao"
printf "%-25s: %s\n" "Clock Atual (GHz)" "$Clock_Atual_GHz"
printf "%-25s: %s\n" "Clock Máximo (GHz)" "$Clock_Maximo_GHz"
printf "%-25s: %s\n" "Clock Externo (MHz)" "$Clock_Externo_MHz"
printf "%-25s: %s\n" "Cache L2 (MB)" "$Cache_L2_MB"
printf "%-25s: %s\n" "Vel. Cache L2 (GHz)" "$Vel_Cache_L2_GHz"
printf "%-25s: %s\n" "Cache L3 (MB)" "$Cache_L3_MB"
printf "%-25s: %s\n" "Vel. Cache L3 (GHz)" "$Vel_Cache_L3_GHz"
printf "%-25s: %s\n" "Threads" "$Threads"
printf "%-25s: %s\n" "Voltagem Atual" "$Voltagem_Atual"
printf "%-25s: %s\n" "Voltagens Suportadas" "$Voltagens_Suportadas"
printf "%-25s: %s\n" "Virtualização Ativa" "$Virtualizacao_Ativa"
printf "%-25s: %s\n" "ID PNP" "$ID_PNP"
printf "%-25s: %s-bit\n" "Largura Endereço" "$Largura_Endereco"
printf "%-25s: %s-bit\n" "Largura Dados" "$Largura_Dados"
printf "%-25s: %s\n" "Estado" "$Estado"
printf "%-25s: %s\n" "Disponibilidade" "$Disponibilidade"
printf "%-25s: %s\n" "Status" "$Status"
printf "%-25s: %s\n" "Info Status" "$Info_Status"
read -p "Press Enter to exit"