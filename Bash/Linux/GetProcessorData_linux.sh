
ID="Indefinido"
ID_Processador="Indefinido"
Numero_Serie="Indefinido"

Nome=$(lscpu | grep "Model name:" | sed 's/Model name:[[:space:]]*//')
Legenda="$Nome"
Fabricante=$(lscpu | grep "Vendor ID:" | awk '{print $3}')
Tipo="Indefinido"  Nucleos_Fisicos=$(lscpu | grep "Core(s) per socket:" | awk '{print $4}')
Nucleos_Ativos=$(nproc --all)
Processos_Logicos=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
Soquete=$(lscpu | grep "Socket(s):" | awk '{print $2}')
Funcao="Indefinido"  Familia=$(lscpu | grep "CPU family:" | awk '{print $3}')
Arquitetura=$(lscpu | grep "^Architecture:" | awk '{print $2}')
Nivel="Indefinido"
PartNumber="Indefinido"

flags=$(grep -m1 "^flags" /proc/cpuinfo | cut -d: -f2)
features=()
if echo "$flags" | grep -qw "fpu"; then features+=("FPU Presente"); fi
if echo "$flags" | grep -E -qw "vmx|svm"; then features+=("Virtualização"); fi
Características=$(IFS=", "; echo "${features[*]}")

Descricao="Indefinido"

cpu_mhz=$(lscpu | grep "CPU MHz:" | awk '{print $3}')
if [[ -n "$cpu_mhz" ]]; then
  Clock_Atual_GHz=$(awk "BEGIN {printf \"%.2f\", $cpu_mhz/1000}")
else
  Clock_Atual_GHz="Indefinido"
fi
Clock_Maximo_GHz="Indefinido"    Clock_Externo_MHz="Indefinido"

Cache_L2_raw=$(lscpu | grep "L2 cache:" | awk '{print $3}')  if [[ "$Cache_L2_raw" =~ ([0-9]+)K ]]; then
  Cache_L2_MB=$(awk "BEGIN {printf \"%.1f\", ${BASH_REMATCH[1]}/1024}")
else
  Cache_L2_MB="Indefinido"
fi
Cache_L3_raw=$(lscpu | grep "L3 cache:" | awk '{print $3}')  if [[ "$Cache_L3_raw" =~ ([0-9]+)K ]]; then
  Cache_L3_MB=$(awk "BEGIN {printf \"%.1f\", ${BASH_REMATCH[1]}/1024}")
else
  Cache_L3_MB="Indefinido"
fi
Vel_Cache_L2_GHz="Indefinido"  Vel_Cache_L3_GHz="Indefinido"

Threads=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

Voltagem_Atual="Indefinido"
Voltagens_Suportadas="Indefinido"
if echo "$flags" | grep -E -qw "vmx|svm"; then
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
