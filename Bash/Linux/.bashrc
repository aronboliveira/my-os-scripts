alias mkd='mkdir'
alias gra='git remote add'
alias gra-o='git remote add origin'
alias ga='git add'
alias gal='git add .'
alias gc='git commit'
alias gca='git commit -a -m'
alias galps='cd "$(git rev-parse --show-toplevel 2>/dev/null)" && git add . && git commit -am'
alias gl='git log'
alias gl-o='git log --oneline'
alias gs='git status'
alias gsw='git show'
alias grl='git reflog'
alias gsl='git shortlog'
alias gci='git check-ignore -v'
alias glr='git ls-remote'
alias glt='git ls-tree'
alias glost='git fsck --lost-found'
alias gps='git push'
alias gps-oh='git push origin HEAD'
alias gps-ohm='git push origin HEAD:main'
alias gpl='git pull'
alias gf='git fetch'
alias gd='git diff'
alias gb='git branch'
alias gbv='git branch -v'
alias gsc='git switch -c'
alias gco='git checkout'
alias gtop='git rev-parse --show-toplevel'
alias gm='git merge'
alias grb='git rebase'
alias grs='git reset'
alias gst='git stash'
alias grs-h='git reset --hard'
alias grs-s='git reset --soft'
alias grs--1='git reset HEAD~1'
alias grs-h--1='git reset --hard HEAD~1'
alias grs-s--1='git reset --soft HEAD~1'
alias grs--og='git reset origin'
alias grs-h--og='git reset --hard origin'
alias grs-s--og='git reset --soft origin'
alias grv='git revert'
alias grv-nc='git revert --no-commit'
alias grv--h='git revert HEAD'
alias grv-m--1='git revert -m 1'
alias gst-ps='git statsh push'
alias gst-pp-u='git stash push --include-untracked'
alias gst-pp-a='git stash push --all'
alias gst-pp-ki='git stash push --keep-index'
alias gst-pp='git stash pop'
alias gst-a='git stash apply'
alias gst-d='git stash drop'
alias gst-l='git stash list'
alias gst-s='git stash show'
alias gst-c='git stash clear'
alias desk='cd ~/Desktop'
alias docs='cd ~/Documents'
alias dl='cd ~/Downloads'
alias ..='cd ..'
alias ...='cd ../..'
alias .ilv='cd _inc/laravel'
alias grep='grep --color=auto'
alias artmrs='php artisan migrate:reset'
alias artmsd='php artisan migrate:fresh --seed'
alias artmst='php artisan migrate:status'
alias artmrs-sd='php artisan migrate:status && php artisan migrate:reset && php artisan migrate:fresh --seed'
alias artcl='php artisan permission:cache-reset && php artisan config:clear && php artisan cache:clear && php artisan optimize:clear && php artisan route:clear && php artisan view:clear && php artisan clear-compiled'
alias artsv='php artisan serve'
alias artrtl='php artisan route:list --sort=uri'
alias laravel-rm-cache='rm -f bootstrap/cache/services.php && rm -f bootstrap/cache/packages.php && rm -f bootstrap/cache/compiled.php && rm -f bootstrap/cache/routes.php'
alias compdp='composer dump-autoload -o'
alias mysqlr='mysql -u root -p'
alias list-files='find . -type f -exec sh -c '\''
	for file do
		basename=$(basename "$file")
		size=$(stat -c "%s" "$file")
		printf "NAME: %s  |  PATH: %s  |  SIZE: %s\n\n" "$basename" "$file" "$size"
	done
'\'' sh {} +'
alias contains-files--r='find . -type d -exec sh -c '\''[ -n "$(find "$0" -maxdepth 1 -type f -print -quit)" ]'\'' {} \; -print'
alias contains-files='find . -maxdepth 1 -type d -exec sh -c '\''[ -n "$(find "$0" -maxdepth 1 -type f -print -quit)" ]'\'' {} \; -print'
alias clines--nvd='find . -type f ! -path ".vendor/*" ! -path "./node_modules/*" -print0 | xargs -0 cat | wc -l'
alias clear-compressed='_find_matching_files() { if [ $# -eq 0 ]; then echo "Usage: find_matching_files <ext1> [ext2] [ext3] ..."; echo "Example: find_matching_files xci ns"; return 1; fi; local conditions=""; for ext in "$@"; do if [ -n "$conditions" ]; then conditions="$conditions -o -name \"\${base_path}.$ext\""; else conditions="-name \"\${base_path}.$ext\""; fi; done; local compressed_files=$(find . -type f \( -name "*.7z" -o -name "*.rar" -o -name "*.zip" \) | sed "s/\.[^.]*$//"); for base_path in $compressed_files; do local matching_files=$(eval "find . -type f \( $conditions \)"); if [ -n "$matching_files" ]; then echo "Found matching files for base path: $base_path"; echo "$matching_files"; echo; local compressed_file=""; for ext in 7z rar zip; do if [ -f "${base_path}.$ext" ]; then compressed_file="${base_path}.$ext"; break; fi; done; if [ -n "$compressed_file" ]; then echo "Compressed file: $compressed_file"; read -p "Do you want to delete '\''$compressed_file'\''? (y/N): " choice; case "$choice" in y|Y|yes|Yes|YES) rm -f "$compressed_file"; echo "Deleted: $compressed_file";; *) echo "Skipped: $compressed_file";; esac; echo "----------------------------------------"; fi; fi; done; }; _find_matching_files'

calc_storage() {
  local target_input="${1:-c:}"
  local drive_letter="${target_input:0:1}"
  drive_letter="${drive_letter,,}"
  drive_letter="${drive_letter//[^a-z]/}"
  local target_dir="/${drive_letter}"
  printf "Calculating storage for: %s\n" "$target_dir" >&2
  local last_dir=""
  find "$target_dir" -type f 2>/dev/null | \
  while IFS= read -r file; do
    local dir="${file%/*}"
    if [[ "$dir" != "$last_dir" ]]; then
      printf "Reading directory: %s\n" "$dir" >&2
      last_dir="$dir"
    fi
    stat -c "%s" "$file" 2>/dev/null
  done | \
  awk '{ sum += $1 } END { printf "Total: %.2f GB\n", sum/1073741824 }'
}
alias calc-storage=calc_storage

pack_files() {
    local files
    local acc=0
    local pack_count=1
    local to_push_dir=""
    readarray -t files < <(find . -type f)
    for file in "${files[@]}"; do
        if [ $acc -eq 100 ] || [ $acc -eq 0 ]; then
            to_push_dir="pack${pack_count}"
            mkdir -p "$to_push_dir"
            echo "Packing files into directory: $to_push_dir"
            ((pack_count++))
            acc=0
        fi
        mv "$file" "$to_push_dir/"
        ((acc++))
    done
    echo "Packed ${#files[@]} files into $((pack_count - 1)) directories"
}
alias packf=pack_files

sanitize_dirnames() {
    local recurse=0
    [[ "$1" == "-r" ]] && recurse=1
    local find_opts=(-type d)
    (( recurse )) || find_opts+=(-maxdepth 1)
    
    find . "${find_opts[@]}" -print0 | while IFS= read -r -d $'\0' dir; do
        base="${dir##*/}"
        new_base=$(echo "$base" | sed 's/[^a-zA-Z0-9_]/__/g' | tr '[:upper:]' '[:lower:]')
        if [[ "$new_base" != "$base" ]]; then
            echo -e "\n\033[32mRenaming '$base' to '$new_base'\033[0m\n"
            mv -f "$dir" "${dir%/*}/$new_base"
        fi
    done
    
    dirs=()
    while IFS= read -r -d $'\0'; do dirs+=("$REPLY"); done < <(find . "${find_opts[@]}" -print0)
    
    echo -en "\n\033[36mReplace multiple underscores with single? [Y/N] \033[0m"
    read -r choice
    if [[ "${choice^^}" == "Y" ]]; then
        for dir in "${dirs[@]}"; do
            base="${dir##*/}"
            new_base=$(echo "$base" | sed 's/__+/_/g')
            [[ "$new_base" == "$base" ]] && continue
            echo -e "\n\033[32mRenaming '$base' to '$new_base'\033[0m\n"
            mv -f "$dir" "${dir%/*}/$new_base"
        done
        dirs=()
        while IFS= read -r -d $'\0'; do dirs+=("$REPLY"); done < <(find . "${find_opts[@]}" -print0)
    fi
    
    echo -en "\n\033[36mTrim long names to 255 characters? [Y/N] \033[0m"
    read -r choice
    if [[ "${choice^^}" == "Y" ]]; then
        for dir in "${dirs[@]}"; do
            base="${dir##*/}"
            [[ ${#base} -le 255 ]] && continue
            new_base="${base:0:255}"
            echo -e "\n\033[33mTrimming '$base' (length ${#base}) to '$new_base'\033[0m\n"
            mv -f "$dir" "${dir%/*}/$new_base"
        done
    fi
}
alias Sanitize-Dirnames='sanitize_dirnames'

sanitize_filenames() {
    local recurse=0
    [[ "$1" == "-r" ]] && recurse=1
    local find_opts=(-type f)
    (( recurse )) || find_opts+=(-maxdepth 1)
    
    find . "${find_opts[@]}" -print0 | while IFS= read -r -d $'\0' file; do
        dir="${file%/*}"
        base="${file##*/}"
        ext="${base##*.}"
        [[ "$base" == "$ext" ]] && ext="" || base_noext="${base%.*}"
        new_base=$(echo "$base_noext" | sed 's/[^a-zA-Z0-9_]/__/g' | tr '[:upper:]' '[:lower:]')
        new_name="$new_base${ext:+.${ext}}"
        [[ "$new_name" == "$base" ]] && continue
        echo -e "\n\033[32mRenaming '$base' to '$new_name'\033[0m\n"
        mv -f "$file" "$dir/$new_name"
    done
    
    files=()
    while IFS= read -r -d $'\0'; do files+=("$REPLY"); done < <(find . "${find_opts[@]}" -print0)
    
    echo -en "\n\033[36mReplace multiple underscores with single? [Y/N] \033[0m"
    read -r choice
    if [[ "${choice^^}" == "Y" ]]; then
        for file in "${files[@]}"; do
            dir="${file%/*}"
            base="${file##*/}"
            ext="${base##*.}"
            [[ "$base" == "$ext" ]] && ext="" || base_noext="${base%.*}"
            new_base=$(echo "$base_noext" | sed 's/__+/_/g')
            new_name="$new_base${ext:+.${ext}}"
            [[ "$new_name" == "$base" ]] && continue
            echo -e "\n\033[32mRenaming '$base' to '$new_name'\033[0m\n"
            mv -f "$file" "$dir/$new_name"
        done
        files=()
        while IFS= read -r -d $'\0'; do files+=("$REPLY"); done < <(find . "${find_opts[@]}" -print0)
    fi
    
    echo -en "\n\033[36mTrim long names to 255 characters? [Y/N] \033[0m"
    read -r choice
    if [[ "${choice^^}" == "Y" ]]; then
        for file in "${files[@]}"; do
            base="${file##*/}"
            ext="${base##*.}"
            [[ "$base" == "$ext" ]] && { ext=""; base_noext="$base"; } || base_noext="${base%.*}"
            max_base_len=$((255 - ${#ext} - ${ext:+-1}))
            [[ ${#base_noext} -le $max_base_len ]] && continue
            new_base="${base_noext:0:$max_base_len}"
            new_name="$new_base${ext:+.${ext}}"
            dir="${file%/*}"
            echo -e "\n\033[33mTrimming '$base' (length ${#base}) to '$new_name'\033[0m\n"
            mv -f "$file" "$dir/$new_name"
        done
    fi
}
alias Sanitize-Filenames='sanitize_filenames'

sanitize_names() {
    local recurse=""
    [[ "$1" == "-r" ]] && recurse="-r"
    echo -en "\n\033[36mSanitize directory names? [Y/N] \033[0m"
    read -r choice
    if [[ "${choice^^}" == "Y" ]]; then
        echo "Sanitizing directory names..."
        sanitize_dirnames $recurse
    fi
    echo -en "\n\033[36mSanitize file names? [Y/N] \033[0m"
    read -r choice
    if [[ "${choice^^}" == "Y" ]]; then
        echo "Sanitizing file names..."
        sanitize_filenames $recurse
    fi
}
alias Sanitize-Names='sanitize_names'


