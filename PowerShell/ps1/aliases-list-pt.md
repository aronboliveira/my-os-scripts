# Perfil PowerShell — Aliases Publicáveis

Todos os aliases publicáveis de `Profile.pub.ps1`, agrupados por região.
Transpilados da seção publicável do Bash para equivalentes em PowerShell (apenas itens multiplataforma).

---

## System_Setup

[Agenda a finalização de um processo em um horário específico]

- schedule-kill-sequence

[Define ajuste OOM de um processo como crítico (-1000)]

- set-ps-critical

[Lista todas as variáveis de ambiente (Get-ChildItem Env:), ordenadas alfabeticamente]

- show-all-env-vars

[Lista todas as variáveis exportadas (System.Environment), ordenadas alfabeticamente]

- show-all-printenv-vars

[Lista todas as variáveis do PowerShell (Get-Variable), ordenadas alfabeticamente]

- show-all-sh-vars

[Mostra a arquitetura da máquina host (RuntimeInformation)]

- show-hosttype

[Mostra o caminho do diretório home do usuário atual]

- show-home

[Mostra o nome do usuário atual]

- show-user

[Mostra a versão e edição do PowerShell atual]

- show-shell

[Mostra o diretório de trabalho atual]

- show-wrkdir

## Pretty_System_Setup

[Exibe todas as variáveis de ambiente com cabeçalho e linhas numeradas]

- show-all-env-vars-pretty

[Exibe todas as variáveis exportadas com cabeçalho e linhas numeradas]

- show-all-printenv-vars-pretty

[Exibe todas as variáveis do PowerShell com cabeçalho e linhas numeradas]

- show-all-sh-vars-pretty

## Basic_Commands

[Atalho para mkdir (New-Item -ItemType Directory)]

- mkdir-p

[Decodifica uma string URI codificada em porcentagem via System.Uri.UnescapeDataString — $Uri: URI para decodificar (obrigatório)]

- uri-decode

[Printf com largura de campo, delimitador e substituição via regex — $Delimiter, $Width, $Target (obrigatório), $Pattern (obrigatório), $Substitute (obrigatório)]

- printf-tr

[Lista arquivos com números de índice e exibe conteúdo por índice — $Index: índice base-1 (padrão: 1)]

- cat-indexed

[Executa múltiplos blocos de script contra um único argumento alvo — $Target (obrigatório), $Commands (obrigatório)]

- run-cmds

[Saída personalizada de ls mostrando colunas de hora, tamanho e nome — $Path (padrão: ".")]

- ls-lah-859

[Conta total de linhas no diretório excluindo pastas vendor]

- wc-l-novendors

[Calcula dígitos verificadores Módulo N para uma string numérica (ex. CPF mod-11, CNPJ) — $State: string de dígitos (obrigatório), $Total: base do módulo (obrigatório)]

- calculate-check-sum
- calc-checksum

## Pretty_Basic_Commands

[Decodificação formatada de URI mostrando entrada e saída decodificada]

- uri-decode-pretty

[Lista formatada de arquivos por índice com exibição opcional de conteúdo]

- cat-indexed-pretty

[Execução formatada de múltiplos comandos contra um alvo com saída por comando]

- run-cmds-pretty

[Resultado formatado de printf-tr com cabeçalho]

- printf-tr-pretty

## File_Analysis

[Verifica se um arquivo tem múltiplas linhas em branco consecutivas — $File (obrigatório)]

- is-mblank

[Lista arquivos no diretório atual que têm múltiplas linhas em branco consecutivas]

- ls-mblank

[Lista arquivos com nome, caminho e tamanho]

- list-files

[Verifica quais diretórios no dir atual contêm arquivos — switch $Recurse para recursivo]

- contains-files

## Filesystem_Utilities

[Exibe a lista de mimeapps do usuário]

- get-mimeapps
- cat-mimeapps

[Exibe a lista de mimeapps compartilhada]

- get-share-mimeapps
- cat-share-mimeapps

[Exibe todas as listas de mimeapps]

- get-all-mimeapps
- cat-all-mimeapps

[Exibe teclas Compose do X11]

- get-compose-chars
- cat-compose-chars
- show-compose-chars

[Empacota todos os arquivos no diretório atual em subdiretórios de 100 arquivos cada]

- packf

[Renomeia todos os arquivos no diretório atual para nomes alfanuméricos aleatórios de 16 caracteres, preservando extensões]

- fully-randomized-file-names

[Alias para Rename-FilesRandomly]

- randomize-filenames

[Alias para Rename-FilesRandomly (forma abreviada)]

- rand-fn

## Git_Aliases

[Log git formatado mostrando email do autor, data e assunto para todas as branches]

- git-log-pretty

[Mostra estatísticas git: linhas adicionadas/removidas, contagem de linhas do projeto, contagem de arquivos, contagem de commits]

- git-stats

### Git_Basic

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

### Git_Log_Status

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

### Git_Remote

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

### Git_Branch_Diff

[git diff]

- gd

[git branch]

- gb

[git branch -v]

- gbv

[git switch -c (criar nova branch)]

- gsc

[git checkout]

- gco

[git rev-parse --show-toplevel (mostrar raiz do repo)]

- gtop

[git merge]

- gm

[git rebase]

- grb

### Git_Reset_Revert

[git reset]

- grs

[git reset --hard]

- grs-h

[git reset --soft]

- grs-s

[git reset HEAD~1 (desfazer último commit, manter alterações)]

- grs--1

[git reset --hard HEAD~1 (desfazer último commit, descartar alterações)]

- grs-h--1

[git reset --soft HEAD~1 (desfazer último commit, manter staged)]

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

[git revert -m 1 (reverter um merge commit, manter primeiro pai)]

- grv-m--1

### Git_Stash

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

## Navigation_Aliases

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

## Laravel_PHP_Aliases

[Executa php artisan migrate:reset]

- artmrs

[Executa php artisan migrate:fresh --seed]

- artmsd

[Executa php artisan migrate:status]

- artmst

[Executa migrate:status, migrate:reset e migrate:fresh --seed em sequência]

- artmrs-sd

[Limpa todos os caches do Laravel (permissões, config, cache, optimize, route, view, compiled)]

- artcl

[Executa php artisan serve]

- artsv

[Reset completo do Laravel: limpa todos os caches, remove arquivos de cache bootstrap, dump autoload, reset & reseed migrations, lista rotas e serve]

- artclrs

[Executa php artisan route:list --sort=uri]

- artrtl

[Remove arquivos de cache bootstrap do Laravel (services, packages, compiled, routes)]

- laravel-rm-cache

[Executa composer dump-autoload -o]

- compdp

[Login MySQL como root com prompt de senha]

- mysqlr

## HTML_CSS_Tools

[Remove todos os comentários HTML de um arquivo e reformata com Prettier]

- strip-html-comments

[Extrai conteúdo de style de um arquivo HTML, minifica com clean-css-cli e exibe tamanhos original vs minificado]

- extract-min-css

[Conta comentários HTML e total de linhas em um arquivo]

- count-html-comments

[Verifica qual CLI de minificação CSS está disponível (csso ou clean-css-cli)]

- check-css-minifier

[Injeta um arquivo CSS minificado no bloco style de um arquivo HTML]

- inject-min-css

## Pretty_HTML_CSS_Tools

[Remove comentários HTML formatado mostrando contagem antes/depois]

- strip-html-comments-pretty

[Extração e minificação formatada de CSS com comparação de tamanho]

- extract-min-css-pretty

[Contagem formatada de comentários HTML e linhas em um arquivo]

- count-html-comments-pretty

[Verificação formatada de disponibilidade de minificador CSS com status ✓/✗]

- check-css-minifier-pretty

[Injeção formatada de CSS minificado em HTML com comparação de linhas]

- inject-min-css-pretty
