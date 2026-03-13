# O QUE É ISSO?

Este é um arquivo com a intenção de _facilitar o entendimento_ do propósito de cada alias e função no .bashrc deste repositório;

---

# Bash Aliases — Publicável

Todos os aliases publicáveis de `~/.bashrc`, agrupados por região.

---

## PUBLICABLE_CODE

### System_Setup

[Ativa renderização GL de software (Mesa llvmpipe), persiste no bashrc, opcionalmente desativa composição X11 — flags: --no-persist, --no-composite]

- setup-software-gl

[Mostra o tipo de sessão de display atual (x11 ou wayland)]

- show-display-session

[Mostra o nome da sessão desktop atual]

- show-desktop-session

[Mostra o nome da unidade de serviço do gerenciador de display ativo via systemctl]

- show-display-manager

[Mostra o binário padrão do gerenciador de display de /etc/X11/default-display-manager]

- show-display-manager-x11

[Mostra o identificador do ambiente desktop atual ($XDG_CURRENT_DESKTOP)]

- show-current-de

[Detecta o gerenciador de display ativo e mostra sua configuração de greeter (suporta LightDM, GDM3, SDDM, LXDM, XDM, SLiM)]

- show-greeter

[Mostra as configurações KDE do SDDM de /etc/sddm.conf.d/kde_settings.conf]

- cat-kde-settings

[Mostra a configuração principal do GDM3 de /etc/gdm3/gdm3.conf]

- cat-gdm3-conf

[Mostra a configuração daemon do GDM3 de /etc/gdm3/daemon.conf]

- cat-gdm3-daemon

[Mostra a configuração personalizada do GDM3 de /etc/gdm3/custom.conf]

- cat-gdm3-custom

[Instala wmctrl se estiver faltando e mostra informações do gerenciador de janelas via wmctrl -m]

- show-win-mng-m

[Detecta o gerenciador de janelas em execução escaneando a lista de processos contra 50+ WMs conhecidos X11/Wayland]

- show-win-mng

[Mostra processos de compositor de tela em execução (picom, compton, kwin, mutter, xfwm, wayfire)]

- show-screen-compositor

[Mostra processos de bloqueador de tela em execução (xscreensaver, light-locker, swaylock, i3lock)]

- show-screen-locker

[Lista bibliotecas runtime de toolkit GUI instaladas (GTK e Qt, excluindo pacotes -dev)]

- show-installed-tks

[Instala backends Flatpak e Snap do plasma-discover]

- install-plasma-backends

### Network_Procedures

[Sonda um host de rede com ARP, ping, netcat e busca de rota — $1: IP alvo (obrigatório), $2: porta alvo (opcional) — flags: --gateway, --local]

- net-probe

[Executa powerstat (RAPL) e redireciona saída para ~/.logs/ — $1: duração em segundos (padrão: 3600), $2: intervalo de amostragem em segundos (padrão: 1)]

- track-power-usage

### User_Management

[Cria um novo usuário e o adiciona ao grupo sudo — $1: nome de usuário (obrigatório)]

- add-sudo-user

### Desktop_Environment

[Remove Cinnamon DE e seus arquivos de configuração, reconfigura GDM3 — flags: --keep-config]

- remove-cinnamon

[Define Nautilus como gerenciador de arquivos padrão, atualiza helpers XFCE e cache MIME]

- set-nautilus-default

[Oculta Thunar das associações MIME via override de desktop em nível de usuário]

- hide-thunar-mime

[Lista processos de compositor/gerenciador de janelas em execução (gnome-shell, xfwm4, mutter, kwin)]

- ps-compositors

[Mostra recursos experimentais do Mutter via gsettings]

- get-mutter-features

[Reseta recursos experimentais do Mutter para array vazio (com confirmação)]

- reset-mutter-features

[Mostra geometria da janela raiz (largura, altura, profundidade) via xwininfo]

- xwin-root-info

[Lista monitores conectados via xrandr]

- ls-monitors

[Verifica disponibilidade de programas relacionados ao DE (monitores de sistema KDE/GNOME/XFCE, Discover, etc.)]

- check-de-programs

### System_Info_Aliases

#### Kernel_and_OS

[Mostra configuração de boot do GRUB de /boot/grub/grub.cfg]

- cat-grub-boot

[Mostra padrões do GRUB de /etc/default/grub]

- cat-grub-etc

[Mostra release do SO do kernel de /proc/sys/kernel/osrelease]

- cat-k-os

[Mostra informações de release do SO de /etc/os-release]

- cat-etc-os

[Mostra versão do kernel de /proc/version]

- cat-os-v

[Mostra versão do Linux de /proc/version]

- cat-linux-v

[Mostra hostname do kernel de /proc/sys/kernel/hostname]

- cat-k-host

[Mostra linha de comando do kernel de /proc/cmdline]

- cat-cmdline

#### VM_and_Memory

[Mostra valor de swappiness da VM de /proc/sys/vm/swappiness]

- cat-vm-swap

[Mostra modo de overcommit de memória da VM de /proc/sys/vm/overcommit_memory]

- cat-vm-over-mem

[Mostra razão de overcommit da VM de /proc/sys/vm/overcommit_ratio]

- cat-vm-over-ratio

[Mostra informações da CPU de /proc/cpuinfo]

- cat-cpu-inf

[Mostra informações de memória de /proc/meminfo]

- cat-mem-inf

#### Storage_and_Partitions

[Mostra tabela de partições de /proc/partitions]

- cat-partitions

[Mostra tabela de sistemas de arquivos de /etc/fstab]

- cat-fstab

#### Drivers_and_Modules

[Mostra versão do driver NVIDIA de /proc/driver/nvidia/version]

- cat-nvidia-v

[Extrai strings do binário /lib/snapd/snapd]

- stringify-snapd

[Lista arquivos de unidade de serviço systemd em /lib/systemd/system/]

- ls-sys-services

[Lista módulos de kernel DKMS para o kernel atual]

- ls-mod-dkms

[Mostra renderizador OpenGL, versão e status de renderização direta via glxinfo]

- glx-info

#### System_Config_Files

[Mostra configuração do GDM3 de /etc/gdm3/custom.conf]

- cat-gdm3-conf

[Mostra arquivo hosts de /etc/hosts]

- cat-hosts

[Lista nomes de usuário do sistema de /etc/passwd]

- cat-users

[Mostra configuração do servidor SSH de /etc/ssh/sshd_config]

- cat-ssh-cfg

[Mostra arquivo sudoers de /etc/sudoers]

- cat-sudoers

[Mostra todos os arquivos de configuração sysctl de /etc/sysctl.d/]

- cat-sysctl-conf

[Mostra todos os arquivos de chave de host SSH de /etc/ssh/]

- cat-ssh-hosts

[Mostra todos os arquivos de lista de fontes APT de /etc/apt/sources.list.d/]

- cat-src-lists

[Lista usuários do sistema com campo de descrição (username:gecos) de /etc/passwd]

- cat-users-verbose

[Mostra todos os arquivos de configuração modprobe de /etc/modprobe.d/]

- cat-modeprobe-confs

#### Logs_and_Crashes

[Extrai strings de arquivos de crash em /var/crash/ (excluindo crashes de opt e a maioria de usr_bin)]

- stringify-crashes

[Extrai strings do binário de cache de pacotes APT]

- stringify-pkgcache

[Extrai strings do binário de cache de pacotes fonte APT]

- stringify-srcpkgcache

[Lista arquivos de lock de arquivo APT em /var/cache/apt/archives/]

- cat-var-locks

[Mostra log do dpkg de /var/log/dpkg.log]

- cat-dpkg-log

[Mostra log do sistema de /var/log/syslog]

- cat-sys-log

[Mostra log de histórico APT de /var/log/apt/history.log]

- cat-history-log

[Mostra log de terminal APT de /var/log/apt/term.log]

- cat-term-log

[Extrai strings de arquivos de log Xorg em /var/log/]

- stringify-xorg-logs

[Mostra erros de GPU/display/compositor do journal do boot atual — $1: número de linhas para escanear (padrão: 200)]

- journal-gpu-errors

[Mostra erros do GNOME Shell do journal do usuário — $1: número de linhas para escanear (padrão: 100)]

- journal-gnome-errors

[Lista arquivos de erro xsession e diretório de log Xorg]

- ls-xsession-errors

[Busca no Xorg.0.log por erros (EE) e avisos (WW)]

- grep-xorg-errors

[Extrai strings relevantes de crash (segfault, sigsegv, GPU, etc.) do arquivo de crash do VS Code]

- stringify-vscode-crash

#### Applications_and_Icons

[Lista arquivos de aplicativo .desktop do sistema em /usr/share/applications/]

- ls-apps

[Lista arquivos de aplicativo .desktop do usuário em ~/.local/share/applications/]

- ls-apps-u

[Lista temas de ícones em /usr/share/icons/]

- ls-icons

[Extrai strings do script sign-file dos cabeçalhos do kernel]

- stringify-sign-files

[Encontra binários system/KDE/Plasma em /usr/bin]

- find-system-kde-bins

#### VSCode_and_GTK

[Mostra configurações GTK4 de ~/.config/gtk-4.0/settings.ini]

- cat-gtk4-settings

[Mostra settings.json do VS Code]

- cat-vscode-settings

[Mostra keybindings.json do VS Code]

- cat-vscode-keybindings

[Mostra extensions.json do VS Code]

- cat-vscode-extensions

[Mostra snippets de usuário do VS Code]

- cat-vscode-snippets

[Mostra banco de dados SQLite de estado do VS Code (binário)]

- cat-vscode-sqlite-state

[Extrai strings de todos os arquivos de log do VS Code]

- stringify-vscode-logs

[Extrai strings do arquivo recently-used.xbel]

- stringify-recent-xbel

[Extrai strings de arquivos de contexto de chat do GitHub Copilot]

- stringify-copilot-context

[Lista arquivos únicos de workspaceStorage (potencialmente contendo contexto de chat, logs, etc.)]

- find-all-vscode-workspace-files

[Encontra arquivos de log do processo GPU do VS Code]

- find-vscode-gpu-logs

[Mostra entradas de GPU/render/display do log do processo compartilhado do VS Code]

- cat-vscode-sharedprocess-gpu

[Mostra flags de lançamento argv.json do VS Code]

- cat-vscode-argv

[Desabilita GPU no argv.json do VS Code adicionando flags disable-gpu (com backup)]

- vscode-disable-gpu

### Pretty_Aliases

#### Pretty_Kernel_OS

[Imprime configuração de boot do GRUB formatada com números de linha e colorização de sintaxe]

- cat-grub-boot-pretty

[Imprime padrões do GRUB formatados com números de linha e colorização de sintaxe]

- cat-grub-etc-pretty

[Imprime release do SO do kernel formatado com cabeçalho/rodapé]

- cat-k-os-pretty

[Imprime informações de release do SO formatadas com chaves destacadas]

- cat-etc-os-pretty

[Imprime versão do kernel formatada com cabeçalho/rodapé]

- cat-os-v-pretty

[Imprime versão do Linux formatada com cabeçalho/rodapé]

- cat-linux-v-pretty

[Imprime hostname do kernel formatado com cabeçalho/rodapé]

- cat-k-host-pretty

[Imprime linha de comando do kernel formatada, um argumento por linha]

- cat-cmdline-pretty

#### Pretty_VM_Memory

[Imprime valor de swappiness da VM formatado com rótulo]

- cat-vm-swap-pretty

[Imprime modo de overcommit de memória da VM formatado com explicação]

- cat-vm-over-mem-pretty

[Imprime porcentagem de razão de overcommit da VM formatada]

- cat-vm-over-ratio-pretty

[Imprime informações da CPU formatadas com nomes de campo destacados]

- cat-cpu-inf-pretty

[Imprime informações de memória formatadas com nomes de campo destacados]

- cat-mem-inf-pretty

#### Pretty_Storage

[Imprime partições formatadas com sublinhado na linha de cabeçalho]

- cat-partitions-pretty

[Imprime tabela de sistemas de arquivos formatada com números de linha]

- cat-fstab-pretty

#### Pretty_Drivers_Modules

[Imprime versão do driver NVIDIA formatada com números de linha]

- cat-nvidia-v-pretty

[Imprime strings do snapd formatadas (primeiras 200 linhas)]

- stringify-snapd-pretty

[Lista serviços systemd formatados com tipos codificados por cores (service/timer/socket)]

- ls-sys-services-pretty

[Lista módulos DKMS formatados com detalhes de tamanho]

- ls-mod-dkms-pretty

[Imprime arquivos de configuração modprobe formatados com cabeçalhos por arquivo]

- cat-modeprobe-confs-pretty

[Imprime informações OpenGL/GLX formatadas com renderizador codificado por cores e status de renderização direta]

- glx-info-pretty

#### Pretty_System_Config

[Imprime configuração do GDM3 formatada com números de linha]

- cat-gdm3-conf-pretty

[Imprime arquivo hosts formatado com endereços IP destacados]

- cat-hosts-pretty

[Imprime nomes de usuário do sistema formatados em colunas com root destacado]

- cat-users-pretty

[Imprime usuários com descrições formatados em formato de duas colunas]

- cat-users-verbose-pretty

[Imprime configuração do servidor SSH formatada com números de linha]

- cat-ssh-cfg-pretty

[Imprime arquivo sudoers formatado com números de linha]

- cat-sudoers-pretty

[Imprime arquivos de configuração sysctl formatados com cabeçalhos por arquivo]

- cat-sysctl-conf-pretty

[Imprime arquivos de chave de host SSH formatados com cabeçalhos por arquivo]

- cat-ssh-hosts-pretty

[Imprime arquivos de lista de fontes APT formatados com cabeçalhos por arquivo]

- cat-src-lists-pretty

#### Pretty_Logs

[Imprime strings de arquivo de crash formatadas com cabeçalhos por arquivo (primeiras 50 linhas cada)]

- stringify-crashes-pretty

[Imprime strings de cache de pacotes formatadas (primeiras 200 linhas)]

- stringify-pkgcache-pretty

[Imprime strings de cache de pacotes fonte formatadas (primeiras 200 linhas)]

- stringify-srcpkgcache-pretty

[Imprime lock de arquivo APT formatado com ícone de cadeado]

- cat-var-locks-pretty

[Imprime log do dpkg formatado (últimas 100 linhas) com install/remove/upgrade codificados por cores]

- cat-dpkg-log-pretty

[Imprime log do sistema formatado (últimas 100 linhas) com erros e avisos codificados por cores]

- cat-sys-log-pretty

[Imprime log de histórico APT formatado com Start-Date/End-Date/Commandline codificados por cores]

- cat-history-log-pretty

[Imprime log de terminal APT formatado (últimas 200 linhas)]

- cat-term-log-pretty

[Imprime strings de log Xorg formatadas com cabeçalhos por arquivo (últimas 40 linhas cada)]

- stringify-xorg-logs-pretty

[Imprime erros de GPU/display do journal formatados com severidade codificada por cores — $1: linhas (padrão: 200)]

- journal-gpu-errors-pretty

[Imprime erros do GNOME Shell formatados com severidade codificada por cores — $1: linhas (padrão: 100)]

- journal-gnome-errors-pretty

[Lista arquivos de erro xsession formatados com ícones de arquivo]

- ls-xsession-errors-pretty

[Imprime erros (EE) e avisos (WW) do Xorg formatados com codificação de cores]

- grep-xorg-errors-pretty

[Imprime análise de crash do VS Code formatada com nomes de sinal codificados por cores]

- stringify-vscode-crash-pretty

#### Pretty_Apps_Icons

[Lista aplicativos do sistema formatados com sufixo .desktop colorido]

- ls-apps-pretty

[Lista aplicativos do usuário formatados com sufixo .desktop colorido]

- ls-apps-u-pretty

[Lista temas de ícones formatados em colunas]

- ls-icons-pretty

[Imprime strings de sign-file formatadas (primeiras 100 linhas)]

- stringify-sign-files-pretty

[Lista binários system/KDE/Plasma formatados com categorias codificadas por cores]

- find-system-kde-bins-pretty

#### Pretty_VSCode_GTK

[Imprime configurações GTK4 formatadas com números de linha]

- cat-gtk4-settings-pretty

[Imprime settings.json do VS Code formatado (via python3)]

- cat-vscode-settings-pretty

[Imprime keybindings.json do VS Code formatado (via python3)]

- cat-vscode-keybindings-pretty

[Imprime extensions.json do VS Code formatado (via python3)]

- cat-vscode-extensions-pretty

[Imprime snippets do VS Code formatados com cabeçalhos por arquivo]

- cat-vscode-snippets-pretty

[Imprime strings do BD de estado SQLite do VS Code formatadas (primeiras 100 strings extraídas)]

- cat-vscode-sqlite-state-pretty

[Imprime arquivos de log do VS Code formatados com cabeçalhos por arquivo]

- stringify-vscode-logs-pretty

[Imprime arquivos recentes do xbel formatados, extraindo hrefs file://]

- stringify-recent-xbel-pretty

[Imprime arquivos de contexto de chat do Copilot formatados (primeiras 30 linhas cada)]

- stringify-copilot-context-pretty

[Imprime logs do processo GPU do VS Code formatados (últimas 20 linhas cada)]

- find-vscode-gpu-logs-pretty

[Imprime entradas de GPU/render do processo compartilhado do VS Code formatadas com severidade codificada por cores]

- cat-vscode-sharedprocess-gpu-pretty

[Imprime flags de lançamento argv.json do VS Code formatadas (via python3)]

- cat-vscode-argv-pretty

#### Pretty_Desktop_Environment

[Lista compositores/gerenciadores de janelas em execução formatados com PID]

- ps-compositors-pretty

[Imprime valor de recursos experimentais do Mutter formatado]

- get-mutter-features-pretty

[Imprime geometria da janela raiz formatada com ícone de monitor]

- xwin-root-info-pretty

[Lista monitores conectados formatados com entradas indexadas]

- ls-monitors-pretty

[Verifica programas relacionados ao DE formatados com status de marca/cruz]

- check-de-programs-pretty

[Imprime tipo de sessão de display formatado com cabeçalho]

- show-display-session-pretty

[Imprime nome de sessão desktop formatado com cabeçalho]

- show-desktop-session-pretty

[Imprime nome de serviço do gerenciador de display formatado com cabeçalho]

- show-display-manager-pretty

[Imprime caminho do binário do gerenciador de display formatado da configuração X11]

- show-display-manager-x11-pretty

[Imprime ambiente desktop atual formatado com cabeçalho]

- show-current-de-pretty

[Imprime configuração de greeter formatada com detecção de DM e cabeçalhos por seção]

- show-greeter-pretty

[Imprime configurações KDE do SDDM formatadas com cabeçalhos de seção e chaves coloridos]

- cat-kde-settings-pretty

[Imprime configuração principal do GDM3 formatada com cabeçalhos de seção e chaves coloridos]

- cat-gdm3-conf-pretty

[Imprime configuração daemon do GDM3 formatada com cabeçalhos de seção e chaves coloridos]

- cat-gdm3-daemon-pretty

[Imprime configuração personalizada do GDM3 formatada com cabeçalhos de seção e chaves coloridos]

- cat-gdm3-custom-pretty

[Imprime informações do gerenciador de janelas do wmctrl formatadas com campos coloridos]

- show-win-mng-m-pretty

[Imprime gerenciador(es) de janelas detectado(s) formatado(s) com setas indicadoras]

- show-win-mng-pretty

[Imprime compositores de tela em execução formatados com PID]

- show-screen-compositor-pretty

[Imprime bloqueadores de tela em execução formatados com PID]

- show-screen-locker-pretty

[Imprime bibliotecas runtime GTK/Qt instaladas formatadas com colunas de versão]

- show-installed-tks-pretty

### Utilities

#### Package_Management

[Remove todas as revisões de pacote snap desabilitadas]

- prune-snap

[Instala pacotes de idioma português (pt) com prompt de confirmação]

- install-pt-lang-pack

#### Network_Monitoring

[Mede uso de largura de banda de rede entre o início e pressionar Enter (baseado no script de Luke Smith)]

- cat-band

[Como cat-band mas redireciona o resultado de largura de banda para um log com timestamp em ~/.logs/cat-band/]

- cat-band-tee

[Como cat-band-tee mas com duração automática ao invés de Enter — $1: segundos para rastrear (padrão: 60)]

- cat-band-tee-d

#### Backup

[Backup rsync com progresso/checksum, excluindo node_modules, venv, __pycache__, .gradle, .m2, vendor, target, .next, dist, build]

- backup-projects

#### File_Analysis

[Mostra arquivos usados recentemente do banco de dados de arquivos recentes XDG — $1: padrão de filtro de busca (padrão: ".")]

- ls-rec-files

[Verifica se um arquivo tem múltiplas linhas em branco consecutivas — $1: caminho do arquivo (obrigatório)]

- is-mblank

[Lista arquivos no diretório atual que têm múltiplas linhas em branco consecutivas]

- ls-mblank

[Lista arquivos com nome, caminho e tamanho]

- list-files

[Verifica quais diretórios no diretório atual contêm arquivos — flag: -r para recursivo]

- contains-files

#### Hardware_Shortcuts

[Verifica suporte de memória ECC via dmidecode]

- check-ecc

[Atalho para bluetoothctl]

- btctl

[Atalho para systemctl]

- stctl

[Atalho para sudo systemctl]

- su-stctl

[Desconecta todos os dispositivos Bluetooth conectados]

- disconnect-all-bt

#### Basic_Commands

[Atalho para mkdir]

- mkd

[Grep com saída colorida automática]

- grep

[Baixa ISO Desktop amd64 do Ubuntu 24.04.3]

- wget-ubuntu-iso

[Saída ls personalizada mostrando colunas de tempo, tamanho e nome — $1: caminho (padrão: ".")]

- ls-lah-859

[Conta linhas totais no diretório excluindo pastas vendor, node_modules e .git]

- wc-l-novendors

[Lista dispositivos de bloco que não estão montados]

- ls-nomount

[Monta drive NTFS com ntfsfix, opções de montagem apropriadas e adiciona a /etc/fstab — $1: caminho de destino de montagem (obrigatório), $2: caminho do dispositivo de bloco (obrigatório)]

- mount-recover-ntfs

[Monta /dev/sda2 em /mnt/sda2 (ext4 simples)]

- mount-sda2

### Git_Aliases

[Log git formatado mostrando email do autor, data e assunto para todos os branches]

- git-log-pretty

[Mostra estatísticas git: linhas adicionadas/removidas, contagem de linhas do projeto, contagem de arquivos, contagens de commits]

- git-stats

#### Git_Basic

[git remote add]

- gra

[git remote add origin]

- gra-o

[git add]

- ga

[git add .]

- gal

[git commit]

- gc

[git commit -a -m]

- gca

[cd para raiz do repo, então git add . && git commit -am]

- galps

#### Git_Log_Status

[git log]

- gl

[git log --oneline]

- gl-o

[git status]

- gs

[git show]

- gsw

[git reflog]

- grl

[git shortlog]

- gsl

[git check-ignore -v]

- gci

[git ls-remote]

- glr

[git ls-tree]

- glt

[git fsck --lost-found]

- glost

[git fsck --full]

- gfsckf

[git gc --aggressive --prune=now]

- gitgcagro

#### Git_Remote

[git push]

- gps

[git push origin HEAD]

- gps-oh

[git push origin HEAD:main]

- gps-ohm

[git pull]

- gpl

[git fetch]

- gf

#### Git_Branch_Diff

[git diff]

- gd

[git branch]

- gb

[git branch -v]

- gbv

[git switch -c (cria novo branch)]

- gsc

[git checkout]

- gco

[git rev-parse --show-toplevel (mostra raiz do repo)]

- gtop

[git merge]

- gm

[git rebase]

- grb

#### Git_Reset_Revert

[git reset]

- grs

[git reset --hard]

- grs-h

[git reset --soft]

- grs-s

[git reset HEAD~1 (desfaz último commit, mantém alterações)]

- grs--1

[git reset --hard HEAD~1 (desfaz último commit, descarta alterações)]

- grs-h--1

[git reset --soft HEAD~1 (desfaz último commit, mantém staged)]

- grs-s--1

[git reset origin]

- grs--og

[git reset --hard origin]

- grs-h--og

[git reset --soft origin]

- grs-s--og

[git revert]

- grv

[git revert --no-commit]

- grv-nc

[git revert HEAD]

- grv--h

[git revert -m 1 (reverte um commit de merge, mantém primeiro pai)]

- grv-m--1

#### Git_Stash

[git stash]

- gst

[git stash push]

- gst-ps

[git stash push --include-untracked]

- gst-pp-u

[git stash push --all]

- gst-pp-a

[git stash push --keep-index]

- gst-pp-ki

[git stash pop]

- gst-pp

[git stash apply]

- gst-a

[git stash drop]

- gst-d

[git stash list]

- gst-l

[git stash show]

- gst-s

[git stash clear]

- gst-c

[git filter-branch para remover forçadamente README.md de todo o histórico]

- gst-filter-rdm

### Navigation_Aliases

[cd para ~/Desktop]

- desk

[cd para ~/Documents]

- docs

[cd para ~/Downloads]

- dl

[cd um nível de diretório acima]

- ..

[cd dois níveis de diretório acima]

- ...

[cd para _inc/laravel]

- .ilv

### Laravel_PHP_Aliases

[Executa php artisan migrate:reset]

- artmrs

[Executa php artisan migrate:fresh --seed]

- artmsd

[Executa php artisan migrate:status]

- artmst

[Executa migrate:status, migrate:reset, então migrate:fresh --seed em sequência]

- artmrs-sd

[Limpa todos os caches do Laravel (permissions, config, cache, optimize, route, view, compiled)]

- artcl

[Executa php artisan serve]

- artsv

[Reset completo do Laravel: limpa todos os caches, remove arquivos de cache do bootstrap, dump autoload, reseta & semeia migrações, lista rotas, então serve]

- artclrs

[Executa php artisan route:list --sort=uri]

- artrtl

[Remove arquivos de cache do bootstrap do Laravel (services, packages, compiled, routes)]

- laravel-rm-cache

[Executa composer dump-autoload -o]

- compdp

[Login MySQL como root com prompt de senha]

- mysqlr

### Filesystem_Utilities

[Lista arquivos com nome, caminho e tamanho (versão alias inline)]

- list-files

[Encontra diretórios contendo arquivos recursivamente]

- contains-files--r

[Encontra diretórios no diretório atual contendo arquivos]

- contains-files

[Conta linhas totais excluindo vendor/node_modules/.git com total acumulado (versão alias inline)]

- wc-l-total-novendors

[Encontra arquivos compactados (7z/rar/zip) com arquivos extraídos correspondentes e opcionalmente deleta os arquivos]

- clear-compressed

[Empacota todos os arquivos no diretório atual em subdiretórios de 100 arquivos cada]

- packf

---

## POWERSHELL_PROFILE_EQUIVALENTS

### Power_Management

[Suspende/coloca o sistema em sleep via systemctl suspend]

- p-sleep

[Mostra resumo de uso de memória (free -h)]

- diag-mem

### Quick_Open_Folders

[Abre lixeira (trash://) no gerenciador de arquivos do desktop]

- ls-cbin

[Abre pasta Documentos no gerenciador de arquivos do desktop]

- ls-docs

[Abre pasta Desktop no gerenciador de arquivos do desktop]

- ls-desk

[Abre pasta Imagens no gerenciador de arquivos do desktop]

- ls-pics

[Abre pasta de fontes do usuário no gerenciador de arquivos do desktop]

- ls-fonts

### Hardware_Inspection

[Lista dispositivos USB via lsusb]

- ls-usb-dev

[Mostra informações da CPU via lscpu]

- ls-cpu

[Lista controladores USB via lspci]

- ls-usb

[Mostra uso de memória física via free -h]

- ls-mem

[Lista unidades de disco via lsblk -d]

- ls-disks

[Mostra uso de disco lógico (sistema de arquivos) via df -h]

- ls-ldisk

[Mostra status da bateria via acpi -b]

- ls-batt

[Mostra configurações de perfil de energia via powerprofilesctl]

- ls-pwr

[Lista impressoras via lpstat]

- ls-prin

[Mostra informações de GPU/controlador de vídeo via lspci]

- ls-gpu

[Lista monitores conectados via xrandr]

- ls-mons

### System_Info

[Mostra configuração de adaptador de rede via nmcli ou ip addr]

- ls-net

[Mostra informações da BIOS via dmidecode -t bios]

- ls-bios

[Mostra journal do sistema via journalctl]

- ls-logs

[Lista todas as contas de usuário via getent passwd]

- ls-users

[Mostra informações do computador/sistema via uname -a]

- ls-host

[Lista todos os grupos via getent group]

- ls-groups

[Mostra informações do SO via lsb_release -a ou hostnamectl]

- ls-os

[Lista pacotes instalados via dpkg-query ou rpm]

- ls-pkgs

### Hardware_Data_Functions

[Mostra informações detalhadas da CPU via lscpu]

- cpu-info

[Mostra detalhes de hardware de memória via dmidecode -t memory]

- ssram-info

[Mostra informações de armazenamento: dispositivos de bloco com pontos de montagem (lsblk) e uso do sistema de arquivos (df -h)]

- storage-info

[Lista dispositivos USB via lsusb]

- usb-info

[Mostra informações de GPU/controlador de vídeo via lspci]

- video-info

[Mostra dispositivos PCI com informações de driver do kernel via lspci -k]

- pnp-info

[Mostra string de versão OpenGL via glxinfo]

- wddm-info

[Mostra resumo de hardware agrupado via lshw -short]

- lshw

### Services_Network

[Lista serviços ativos via systemctl ou service --status-all]

- ls-svc

[Lista sockets abertos via ss -tunap]

- ls-sock

[Lista redes WiFi disponíveis via nmcli ou iwlist]

- ls-wlan

[Mostra capacidades wireless via iw list ou nmcli]

- ls-wcap

[Mostra drivers de rede via lspci -nnk]

- ls-netdrv

### File_Utilities

[Calcula armazenamento total usado sob um caminho de drive/diretório — $1: caminho alvo (padrão: "c:")]

- calc-storage

[Compacta diretório atual em um arquivo zip, excluindo node_modules e vendor]

- compdir

[Descompacta todos os arquivos (zip/7z/rar) encontrados recursivamente no diretório atual]

- uz-all

[Deleta todos os arquivos compactados (zip/7z/rar) no diretório atual]

- del-comp

[Converte string snake_case para PascalCase — $1: string de entrada (obrigatório)]

- topascal

[Converte string PascalCase/camelCase para snake_case — $1: string de entrada (obrigatório)]

- tosnake

[Sanitiza nomes de diretórios: substitui caracteres especiais por underscores, minúsculas — flag: -r para recursivo]

- sanitize-d

[Sanitiza nomes de arquivos: substitui caracteres especiais por underscores, minúsculas — flag: -r para recursivo]

- sanitize-f

[Sanitiza todos os nomes (diretórios depois arquivos) interativamente — flag: -r para recursivo]

- sanitize-a

### Backup_Analysis

[Backup rsync com retry automático em caso de falha — $1: origem (obrigatório), $2: destino (obrigatório), $3: contagem de retry (padrão: 3), $4: segundos de espera (padrão: 5)]

- bcp

[Mostra pastas mais pesadas por tamanho em GB — $1: caminho raiz (padrão: "."), $2: top N resultados (padrão: 10)]

- hfold

[Mostra arquivos mais pesados por tamanho em GB — $1: caminho raiz (padrão: "."), $2: top N resultados (padrão: 10)]

- hfile

[Mostra uso de disco dos filhos imediatos, ordenado por tamanho — $1: caminho (padrão: ".")]

- du-surface

[Mede distribuição de arquivos entre pasta raiz e uma subpasta — $1: caminho raiz (obrigatório), $2: nome do subdiretório (obrigatório), $3: filtro glob (padrão: "*")]

- mfd

[Busca interativa de arquivos: solicita um padrão de nome de arquivo e busca na árvore do diretório atual]

- sint

[Busca arquivos recursivamente com opções de formato de saída — $1: caminho (padrão: "."), $2: índice de saída 0=caminho completo, 1=apenas nome, 2=stat (padrão: 1), $3: filtro glob (padrão: "*")]

- rsf

[cd em um diretório por índice numérico da listagem do diretório atual — $1: índice (padrão: 0)]

- cd-i

[Extrai todos os arquivos .7z em um diretório — $1: caminho (padrão: ".")]

- exp-7z

[Abre um arquivo por índice numérico no VS Code — $1: caminho (padrão: "."), $2: índice do arquivo (padrão: 0)]

- code-i

[Abre um arquivo Excel (.xls/.xlsx/.xlsm) no LibreOffice Calc — $1: caminho do arquivo (obrigatório)]

- xcl

### Data_Extraction

[Concatena valores de token GPT de um arquivo JSON usando jq — $1: caminho do arquivo JSON (obrigatório)]

- join-tokens

[Conta e lista todos os arquivos .java com contagens totais de arquivo e linhas]

- jdata

[Conta e lista todos os arquivos JS/TS/Vue (.js, .cjs, .mjs, .jsx, .ts, .cts, .mts, .tsx, .vue) com contagens totais]

- jsdata

[Conta e lista todos os arquivos .php com contagens totais de arquivo e linhas]

- phpdata

[Conta e lista todos os arquivos .py com contagens totais de arquivo e linhas]

- pydata

[Conta e lista arquivos correspondentes a padrões glob personalizados com contagens totais — $@: padrões glob (ex: "*.go" "*.rs")]

- pldata

[Remove sublinhados duplos de nomes de arquivos interativamente — $1: caminho (padrão: "."), $2: --no-interactive para pular prompts]

- rmmultius

### Browser_Dev

[Limpa diretórios de cache de código fetch do Chrome/Chromium]

- rm-chromefetch

[Ativa ambiente virtual Python de ./env/bin/activate]

- py-venv

[Executa comandos manage.py do Django — $@: argumentos do manage.py (ex: runserver, migrate)]

- pymng

[Alias para pymng (manage.py do Django)]

- django

[Mata todos os processos do Chrome (SIGKILL)]

- killchrome

[Limpa cache fetch do Chrome/Chromium (variante duplicada)]

- rmchrome-fetch

### Android_ADB

[Lista arquivos mais pesados em um dispositivo Android via ADB com relatórios intermediários e suporte para pausar/retomar]

- ls-heavy-adb

[Lista diretórios mais pesados em um dispositivo Android via ADB com relatórios intermediários e suporte para pausar/retomar]

- ls-heavy-adb-dirs

### Alias_Shortcuts

#### Complex_Functions

[Alias para convert_to_snake_case]

- tosnake

[Alias para compress_current_directory]

- compweb

[Alias para unzip_all]

- unzipall

[Alias para delete_all_compressed]

- deletezip

[Alias para heavy_files]

- getheavfiles

[Alias para heavy_folders]

- getheavdirs

[Alias para measure_file_distribution]

- filedistrib

[Alias para search_interactive]

- isearch

[Alias para recursive_search_files]

- lsrf

[Alias para code_by_index]

- idxcode

[Alias para get_concatenated_gpt_tokens]

- getgpttokens

[Alias para get_java_files_data]

- getjavadata

[Alias para get_js_files_data]

- getjsdata

[Alias para get_php_files_data]

- getphpdata

[Alias para get_python_files_data]

- getpydata

[Alias para get_prog_lang_files_data]

- getplngdata

#### Hardware_Aliases

[Alias para processor_data (lscpu)]

- getprocfull

[Alias para ssram_data (dmidecode -t memory)]

- getssramfull

[Alias para storage_data (lsblk + df)]

- getstoragefull

[Alias para storage_data (lsblk + df)]

- lshw-storage

[Alias para usb_data (lsusb)]

- getusbportfull

[Alias para usb_data (lsusb)]

- lsusb

[Alias para video_data (lspci VGA/3D/display)]

- getvcfull

[Alias para grouped_hardware (lshw -short)]

- gethwfull

#### Storage_Aliases

[Alias para open_recycle_bin (trash://)]

- cbin

#### USB_Aliases

[Alias para get_usb_controller_device (lsusb)]

- getusbcd

[Alias para get_usb_controller (lspci USB)]

- getusbc

#### Proc_Mem_Aliases

[Alias para get_processor (lscpu)]

- getproc

[Alias para get_physical_memory (free -h)]

- getpmem

[Alias para get_disk_drive (lsblk -d)]

- getdd

[Alias para get_logical_disk (df -h)]

- getld

[Alias para get_video_controller (lspci VGA/3D)]

- getvc

[Alias para wddm_version (glxinfo OpenGL version)]

- getwddm

#### Core_System_Aliases

[Alias para get_battery (acpi -b)]

- getbt

[Alias para get_power_setting (powerprofilesctl)]

- getpws

[Alias para get_printers (lpstat)]

- getprn

[Alias para get_bios (dmidecode -t bios)]

- getbios

[Alias para get_computer_system (uname -a)]

- getcs

[Alias para get_operating_system (lsb_release / hostnamectl)]

- getos

[Alias para get_product (dpkg-query / rpm)]

- getprod

[Alias para get_services (systemctl list-units)]

- getsvc

#### Administration_Aliases

[Alias para get_user_account (getent passwd)]

- getua

[Alias para get_group_user (getent group)]

- getgu

[Alias para get_ntlog_event (journalctl)]

- getntlog

#### Network_Aliases

[Alias para get_network_adapter_configuration (nmcli / ip addr)]

- getnac

[Alias para netsh_winsock_catalog (ss -tunap)]

- netshv

[Alias para netsh_wlan (nmcli wifi list)]

- netsha

[Alias para get_wireless_capabilities (iw list)]

- netshc

[Alias para get_net_drivers (lspci network)]

- getndv

#### Quick_Open_Aliases

[Alias para open_recycle_bin]

- recyclebin

[Alias para open_documents]

- documents

[Alias para open_documents]

- docs

[Alias para open_desktop]

- desktop

[Alias para open_desktop]

- dkt

[Alias para open_pictures]

- pictures

[Alias para open_pictures]

- pct

[Alias para diagnose_memory (free -h)]

- memdiag

[Alias para open_fonts]

- fonts

[Alias para open_personalization]

- personalization

### XFCE_Settings

[Abre configurações de display do XFCE]

- deb-st-display

[Abre configurações do gerenciador de energia do XFCE (equivalente a luz noturna)]

- deb-st-nightlight

[Abre configurações de display do XFCE (resolução de tela)]

- deb-st-screenresolution

[Abre configurações de workspace do XFCE (multitarefa/desktops virtuais)]

- deb-st-multitasking

[Mostra diálogo sobre do XFCE]

- deb-st-about

[Mostra diálogo sobre do XFCE (informações do sistema)]

- deb-st-systeminfo

[Abre controle de volume PulseAudio (configurações de som)]

- deb-st-sound

[Abre controle de volume PulseAudio (dispositivos de som)]

- deb-st-sound-devices

[Abre controle de volume PulseAudio (áudio)]

- deb-st-audio

[Abre editor de conexão NetworkManager]

- deb-st-network

[Abre editor de conexão NetworkManager (WiFi)]

- deb-st-wifi

[Abre editor de conexão NetworkManager (Ethernet)]

- deb-st-ethernet

[Abre gerenciador Bluetooth Blueman]

- deb-st-bluetooth

[Abre gerenciador Bluetooth Blueman (abreviado)]

- st-bt

[Abre editor de conexão NetworkManager (proxy)]

- deb-st-proxy

[Abre gerenciador de configurações do XFCE (personalização)]

- deb-st-personalization

[Abre configurações de aparência do XFCE (temas)]

- deb-st-themes

[Abre configurações de aparência do XFCE (cores)]

- deb-st-colors

[Abre configurações de desktop do XFCE (background/papel de parede)]

- deb-st-background

[Abre preferências de screensaver do XFCE (tela de bloqueio)]

- deb-st-lockscreen

[Abre preferências de painel do XFCE (barra de tarefas)]

- deb-st-taskbar

[Abre configurações de aparência do XFCE (fontes)]

- deb-st-fonts

[Abre configurações de mouse do XFCE (cursor/ponteiro)]

- deb-st-cursormousepointer

[Abre system-config-printer (impressoras)]

- deb-st-printers

[Abre configurações de mouse do XFCE]

- deb-st-mouse

[Abre configurações de mouse do XFCE (touchpad)]

- deb-st-touchpad

[Abre configurações de teclado do XFCE]

- deb-st-keyboard

[Abre configurações de mouse do XFCE (caneta/tablet)]

- deb-st-pen

[Abre preferências do Thunar (autoplay)]

- deb-st-autoplay

[Abre gerenciador de arquivos Thunar (USB)]

- deb-st-usb

[Abre admin de tempo/data do XFCE]

- deb-st-dateandtime

[Abre gerenciador de configurações do XFCE (região/idioma)]

- deb-st-regionlanguage

[Abre gerenciador de configurações do XFCE (idioma)]

- deb-st-language

[Abre configurações do gerenciador de energia do XFCE (energia/suspensão)]

- deb-st-powersleep

[Abre configurações do gerenciador de energia do XFCE (economia de bateria)]

- deb-st-batterysaver

[Abre configurações do gerenciador de energia do XFCE (opções de energia)]

- deb-st-poweroptions

[Abre gerenciador de arquivos Thunar (equivalente a storage sense)]

- deb-st-storagesense

[Abre configurações MIME do XFCE (aplicativos padrão)]

- deb-st-defaultapps

[Abre Google Maps no navegador padrão]

- deb-st-maps

[Abre localizador de aplicativos do XFCE (apps & recursos)]

- deb-st-appsfeatures

[Abre gerenciador de pacotes Synaptic (recursos opcionais)]

- deb-st-optionalfeatures

[Abre gerenciador de pacotes Synaptic (programas & recursos)]

- deb-st-programsfeatures

[Abre configurações MIME do XFCE (padrões de aplicativo)]

- deb-st-appdefaults

[Abre users-admin (suas informações)]

- deb-st-yourinfo

[Abre users-admin (opções de login)]

- deb-st-signinoptions

[Abre users-admin (trabalho)]

- deb-st-workplace

[Abre users-admin (outros usuários)]

- deb-st-otherusers

[Inicia Steam (jogos)]

- deb-st-gaming

[Inicia gamemode]

- deb-st-gamemode

[Abre configurações de acessibilidade do XFCE (facilidade de acesso)]

- deb-st-easeofaccess

[Abre configurações de display do XFCE (facilidade de acesso do display)]

- deb-st-display-easeofaccess

[Abre configurações de mouse do XFCE (ponteiro do mouse)]

- deb-st-mousepointer

[Abre configurações de teclado do XFCE (facilidade de acesso do teclado)]

- deb-st-keyboard-easeofaccess

[Abre gerenciador de configurações do XFCE (privacidade)]

- deb-st-privacy

[Executa atualização freshclam do ClamAV (equivalente a Windows Defender)]

- deb-st-windowsdefender

[Executa sudo apt update && sudo apt upgrade (equivalente a Windows Update)]

- deb-st-windowsupdate

[Abre preferências de backup Déjà Dup]

- deb-st-backup

[Abre gerenciador de configurações do XFCE (solucionar problemas)]

- deb-st-troubleshoot

[Echo "Use modo de recuperação GRUB" (recuperação)]

- deb-st-recovery

[Echo "Nenhuma ativação necessária no Linux"]

- deb-st-activation

[Echo "Recurso não disponível no Linux" (encontrar meu dispositivo)]

- deb-st-findmydevice

[Abre gerenciador de configurações do XFCE (configurações de desenvolvedor)]

- deb-st-developers

[Abre localizador de aplicativos do XFCE (equivalente a Cortana)]

- deb-st-cortana

[Abre localizador de aplicativos do XFCE (pesquisa)]

- deb-st-search

[Echo "Realidade mista não suportada nativamente" (holográfico)]

- deb-st-holographic

[Abre gerenciador de arquivos Thunar (equivalente a Explorer)]

- deb-st-explorer

[Abre gerenciador de arquivos Thunar (equivalente a Este PC)]

- deb-st-thispc

[Abre Thunar em ~/Documents]

- deb-st-documents

[Abre Thunar em ~/Downloads]

- deb-st-downloads

[Abre Thunar em ~/Music]

- deb-st-music

[Abre Thunar em ~/Pictures]

- deb-st-pictures

[Abre Thunar em ~/Videos]

- deb-st-videos

[Abre Thunar em ~/Desktop]

- deb-st-desktop

[Abre gerenciador de configurações do XFCE (equivalente a Painel de Controle)]

- deb-st-controlpanel

[Abre gerenciador de configurações do XFCE (equivalente a Ferramentas Administrativas)]

- deb-st-admintools

[Abre lshw-gtk (equivalente a Gerenciador de Dispositivos)]

- deb-st-devicemanager

[Abre GNOME Disks (equivalente a Gerenciamento de Disco)]

- deb-st-diskmgmt

[Abre GNOME Logs (equivalente a Visualizador de Eventos)]

- deb-st-eventvwr

[Abre systemd-manager (equivalente a Serviços)]

- deb-st-services

[Abre htop (equivalente a Gerenciador de Tarefas)]

- deb-st-taskmanager

[Abre dconf-editor (equivalente a Editor do Registro)]

- deb-st-regedit

[Abre terminal XFCE]

- deb-st-terminal

[Abre gerenciador de arquivos Thunar]

- deb-st-filemanager

[Abre galculator (equivalente a Calculadora)]

- deb-st-calculator

[Abre editor de texto Mousepad (equivalente a Bloco de Notas)]

- deb-st-notepad

[Abre GIMP (equivalente a Paint)]

- deb-st-paint

[Abre capturador de tela XFCE (ferramenta de captura de tela)]

- deb-st-screenshot

[Abre Hardinfo (equivalente a msinfo32)]

- deb-st-msinfo32

[Abre systemd-manager (equivalente a msconfig)]

- deb-st-msconfig

[Abre terminal XFCE (equivalente a cmd)]

- deb-st-cmd

[Abre terminal XFCE (equivalente a PowerShell)]

- deb-st-powershell

[Abre localizador de aplicativos do XFCE colapsado (equivalente a diálogo Executar)]

- deb-st-run
