# PowerShell Profile — Publicable Aliases

All publicable aliases from `Profile.pub.ps1`, grouped by region.
Transpiled from the Bash publicable section to PowerShell equivalents (cross-platform items only).

---

## System_Setup

[Schedule a process kill at a specified time]

- schedule-kill-sequence

[Set OOM score adjustment for a process to critical (-1000)]

- set-ps-critical

[List all environment variables (Get-ChildItem Env:), sorted alphabetically]

- show-all-env-vars

[List all exported variables (System.Environment), sorted alphabetically]

- show-all-printenv-vars

[List all PowerShell variables (Get-Variable), sorted alphabetically]

- show-all-sh-vars

[Show host machine architecture (RuntimeInformation)]

- show-hosttype

[Show current user's home directory path]

- show-home

[Show current username]

- show-user

[Show current PowerShell version and edition]

- show-shell

[Show current working directory]

- show-wrkdir

## Pretty_System_Setup

[Pretty-print all environment variables with header and numbered lines]

- show-all-env-vars-pretty

[Pretty-print all exported variables with header and numbered lines]

- show-all-printenv-vars-pretty

[Pretty-print all PowerShell variables with header and numbered lines]

- show-all-sh-vars-pretty

## Basic_Commands

[Shortcut for mkdir (New-Item -ItemType Directory)]

- mkdir-p

[Decode a percent-encoded URI string via System.Uri.UnescapeDataString — $Uri: URI to decode (required)]

- uri-decode

[Printf with field-width, delimiter, and regex substitution — $Delimiter, $Width, $Target (required), $Pattern (required), $Substitute (required)]

- printf-tr

[List files with index numbers and display file contents by index — $Index: 1-based index (default: 1)]

- cat-indexed

[Run multiple script blocks against a single target argument — $Target (required), $Commands (required)]

- run-cmds

[Custom ls output showing time, size, and name columns — $Path (default: ".")]

- ls-lah-859

[Count total lines in directory excluding vendor folders]

- wc-l-novendors

[Calculate Modulus N check digits for a numeric string (e.g. CPF mod-11, CNPJ) — $State: digit string (required), $Total: modulus base (required)]

- calculate-check-sum
- calc-checksum

## Pretty_Basic_Commands

[Pretty-decode a URI string showing input and decoded output]

- uri-decode-pretty

[Pretty-list files by index with optional file content display]

- cat-indexed-pretty

[Pretty-run multiple commands against a target with formatted output per command]

- run-cmds-pretty

[Pretty-print printf-tr result with formatted header]

- printf-tr-pretty

## File_Analysis

[Check if a file has multiple consecutive blank lines — $File (required)]

- is-mblank

[List files in current directory that have multiple consecutive blank lines]

- ls-mblank

[List files with name, path, and size]

- list-files

[Check which directories in current dir contain files — $Recurse switch for recursive]

- contains-files

## Filesystem_Utilities

[Displays the user mimeapps list]

- get-mimeapps
- cat-mimeapps

[Displays shared mimeapps list]

- get-share-mimeapps
- cat-share-mimeapps

[Displays all mimeapps lists]

- get-all-mimeapps
- cat-all-mimeapps

[Displays X11 Compose keys]

- get-compose-chars
- cat-compose-chars
- show-compose-chars

[Pack all files in current directory into subdirectories of 100 files each]

- packf

[Rename all files in the current directory to random 16-char alphanumeric names, preserving extensions]

- fully-randomized-file-names

[Alias for Rename-FilesRandomly]

- randomize-filenames

[Alias for Rename-FilesRandomly (short form)]

- rand-fn

## Git_Aliases

[Pretty git log showing author email, date, and subject for all branches]

- git-log-pretty

[Show git stats: lines added/removed, project line count, file count, commit counts]

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

[cd to repo root, then git add . && git commit -am]

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

[git switch -c (create new branch)]

- gsc

[git checkout]

- gco

[git rev-parse --show-toplevel (show repo root)]

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

[git reset HEAD~1 (undo last commit, keep changes)]

- grs--1

[git reset --hard HEAD~1 (undo last commit, discard changes)]

- grs-h--1

[git reset --soft HEAD~1 (undo last commit, keep staged)]

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

[git revert -m 1 (revert a merge commit, keep first parent)]

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

[cd to ~/Desktop]

- desk

[cd to ~/Documents]

- docs

[cd to ~/Downloads]

- dl

[cd up one directory level]

- ..

[cd up two directory levels]

- ...

[cd to _inc/laravel]

- .ilv

## Laravel_PHP_Aliases

[Run php artisan migrate:reset]

- artmrs

[Run php artisan migrate:fresh --seed]

- artmsd

[Run php artisan migrate:status]

- artmst

[Run migrate:status, migrate:reset, then migrate:fresh --seed in sequence]

- artmrs-sd

[Clear all Laravel caches (permissions, config, cache, optimize, route, view, compiled)]

- artcl

[Run php artisan serve]

- artsv

[Full Laravel reset: clear all caches, remove bootstrap cache files, dump autoload, reset & reseed migrations, list routes, then serve]

- artclrs

[Run php artisan route:list --sort=uri]

- artrtl

[Remove Laravel bootstrap cache files (services, packages, compiled, routes)]

- laravel-rm-cache

[Run composer dump-autoload -o]

- compdp

[MySQL login as root with password prompt]

- mysqlr

## HTML_CSS_Tools

[Strip all HTML comments from a file and reformat with Prettier]

- strip-html-comments

[Extract style content from an HTML file, minify with clean-css-cli, and display original vs minified byte sizes]

- extract-min-css

[Count HTML comments and total lines in a file]

- count-html-comments

[Check which CSS minifier CLI is available (csso or clean-css-cli)]

- check-css-minifier

[Inject a minified CSS file into the style block of an HTML file]

- inject-min-css

## Pretty_HTML_CSS_Tools

[Pretty-strip HTML comments showing before/after count]

- strip-html-comments-pretty

[Pretty-extract and minify CSS with byte-size comparison]

- extract-min-css-pretty

[Pretty-count HTML comments and lines in a file]

- count-html-comments-pretty

[Pretty-check CSS minifier availability with checkmark/cross status]

- check-css-minifier-pretty

[Pretty-inject minified CSS into HTML with line count comparison]

- inject-min-css-pretty
