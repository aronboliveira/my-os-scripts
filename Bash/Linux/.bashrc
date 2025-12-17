alias check-ecc='sudo dmidecode -t memory | grep -i "error\|ecc\|correction"'
# REPLACE SDB3 WITH YOUR ACTUAL VOLUME, CHECKED WITH lsblk
alias setup-luks-sdb3='sudo cryptsetup luksOpen /dev/sdb3 sdb3'
alias disconnect-all-bt='for device in $(bluetoothctl devices Connected | awk '"'"'{print $2}'"'"'); do bluetoothctl disconnect "$device"; done'
alias bt-on='bluetoothctl power on'
alias bt-off='bluetoothctl power off'
alias bt-scan='bluetoothctl scan on'
alias bt-devices='bluetoothctl devices'
alias mount-sdb3='\
    sudo lvdisplay; \
    sudo vgchange -ay ubuntu-vg; \
    sudo mkdir -p /mnt/ubuntu--vg/ubuntu--lv; \
    sudo mount /dev/mapper/ubuntu--vg-ubuntu--lv /mnt/ubuntu--vg/ubuntu--lv; \
    echo "Successfully mounted /dev/sdb3 to /mnt/ubuntu--vg/ubuntu--lv";'
alias disconnect-all-bt='for device in $(bluetoothctl devices Connected | awk '"'"'{print $2}'"'"'); do bluetoothctl disconnect "$device"; done'
alias git-log-pretty='git log --all --pretty=format:"%ae - %cd - %s" --date=short'
alias git-stats='\
    AUTHOR="${1:-$(git config user.email)}"; \
    echo "Author email: $AUTHOR"; \
    echo ""; \
    git log --author="$AUTHOR" --pretty=tformat: --numstat 2>/dev/null | \
    awk '\''{ add += $1; subs += $2; loc += $1 - $2 } END { \
        printf "Lines added: %s\nLines removed: %s\nNet lines (changed): %s\n", add, subs, loc \
    }'\''; \
    echo ""; \
    echo "Total number of lines in the project (ignoring vendors):"; \
    find . -type f \
        ! -path '\''*/vendor/*'\'' \
        ! -path '\''*/node_modules/*'\'' \
        ! -path '\''*/.git/*'\'' \
        ! -path '\''*/dist/*'\'' \
        ! -path '\''*/build/*'\'' \
        ! -path '\''*/./*'\'' \
        -exec wc -l {} + 2>/dev/null | tail -1 | awk '\''{print $1}'\''; \
    echo "Total number of files in the project (ignoring vendors):"; \
    find . -type f \
        ! -path '\''*/vendor/*'\'' \
        ! -path '\''*/node_modules/*'\'' \
        ! -path '\''*/.git/*'\'' \
        ! -path '\''*/dist/*'\'' \
        ! -path '\''*/build/*'\'' \
        ! -path '\''*/./*'\'' \
        | wc -l 2>/dev/null; \
    echo ""; \
    echo "Total number of commits registered for the remote repository:"; \
    git rev-list --count --all 2>/dev/null || echo "No remote repository"; \
    echo "Total number of commits registered for the branch:"; \
    git rev-list --count HEAD 2>/dev/null;'
alias gst-filter-rdm='git filter-branch --force --prune-empty --index-filter "git rm --cached --ignore-unmatch README.md" cat -- --all'
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
alias wc-l-total-novendors="files=0; total=0; \
while IFS= read -r -d \$'\0' file; do \
  lines=\$(wc -l < \"\$file\"); \
  total=\$((total+lines)); \
  files=\$((files+1)); \
  printf \"%s %d\n\" \"\$file\" \"\$total\"; \
done < <(find . -type f \
     ! -path '*/vendor/*' \
     ! -path '*/node_modules/*' \
     ! -path '*/.git/*' \
     -print0); \
echo \"-> TOTAL NUMBER OF LINES IN THE DIRECTORY: \$total, distributed in \$files files\""
alias clear-compressed='_find_matching_files() { if [ $# -eq 0 ]; then echo "Usage: find_matching_files <ext1> [ext2] [ext3] ..."; echo "Example: find_matching_files xci ns"; return 1; fi; local conditions=""; for ext in "$@"; do if [ -n "$conditions" ]; then conditions="$conditions -o -name \"\${base_path}.$ext\""; else conditions="-name \"\${base_path}.$ext\""; fi; done; local compressed_files=$(find . -type f \( -name "*.7z" -o -name "*.rar" -o -name "*.zip" \) | sed "s/\.[^.]*$//"); for base_path in $compressed_files; do local matching_files=$(eval "find . -type f \( $conditions \)"); if [ -n "$matching_files" ]; then echo "Found matching files for base path: $base_path"; echo "$matching_files"; echo; local compressed_file=""; for ext in 7z rar zip; do if [ -f "${base_path}.$ext" ]; then compressed_file="${base_path}.$ext"; break; fi; done; if [ -n "$compressed_file" ]; then echo "Compressed file: $compressed_file"; read -p "Do you want to delete '\''$compressed_file'\''? (y/N): " choice; case "$choice" in y|Y|yes|Yes|YES) rm -f "$compressed_file"; echo "Deleted: $compressed_file";; *) echo "Skipped: $compressed_file";; esac; echo "----------------------------------------"; fi; fi; done; }; _find_matching_files'

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


### POWERSHELL PROFILE EQUIVALENTS ###

set_power_sleep() {
  systemctl suspend
}
alias p-sleep='set_power_sleep'

diagnose_memory() {
  free -h
}
alias diag-mem='diagnose_memory'

get_file_manager() {
  de="${XDG_CURRENT_DESKTOP,,}"
  case "$de" in
    gnome*|unity)     echo nautilus   ;;
    kde*|plasma)      echo dolphin    ;;
    cinnamon)         echo nemo       ;;
    xfce*|xubuntu)    echo thunar     ;;
    mate)             echo caja       ;;
    lxde)             echo pcmanfm    ;;
    lxqt)             echo pcmanfm-qt ;;
    *)                echo xdg-open   ;;
  esac
}

get_user_dir() {
  if command -v xdg-user-dir >/dev/null 2>&1; then
    xdg-user-dir "$1"
  else
    case "$1" in
      DESKTOP)   echo "$HOME/Desktop"   ;;
      DOCUMENTS) echo "$HOME/Documents" ;;
      PICTURES)  echo "$HOME/Pictures"  ;;
      DOWNLOAD)  echo "$HOME/Downloads" ;;
      MUSIC)     echo "$HOME/Music"     ;;
      VIDEOS)    echo "$HOME/Videos"    ;;
      *)         echo "$HOME"          ;;
    esac
  fi
}

set_power_sleep() {
  systemctl suspend
}
alias p-sleep='set_power_sleep'

open_recycle_bin() {
  "$(get_file_manager)" trash://
}
alias ls-cbin='open_recycle_bin'

open_documents() {
  "$(get_file_manager)" "$(get_user_dir DOCUMENTS)"
}
alias ls-docs='open_documents'

open_desktop() {
  "$(get_file_manager)" "$(get_user_dir DESKTOP)"
}
alias ls-desk='open_desktop'

open_pictures() {
  "$(get_file_manager)" "$(get_user_dir PICTURES)"
}
alias ls-pics='open_pictures'

open_fonts() {
  "$(get_file_manager)" "${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
}
alias ls-fonts='open_fonts'

get_usb_controller_device() {
  lsusb
}
alias ls-usb-dev='get_usb_controller_device'

get_processor() {
  lscpu
}
alias ls-cpu='get_processor'

get_usb_controller() {
  lspci | grep -i usb
}
alias ls-usb='get_usb_controller'

get_physical_memory() {
  free -h
}
alias ls-mem='get_physical_memory'

get_disk_drive() {
  lsblk -d
}
alias ls-disks='get_disk_drive'

get_logical_disk() {
  df -h
}
alias ls-ldisk='get_logical_disk'

get_battery() {
  acpi -b
}
alias ls-batt='get_battery'

get_power_setting() {
  if command -v powerprofilesctl >/dev/null 2>&1; then
    powerprofilesctl list
  else
    echo powerprofilesctl not installed
  fi
}
alias ls-pwr='get_power_setting'

get_printers() {
  lpstat -p -d
}
alias ls-prin='get_printers'

get_video_controller() {
  lspci | grep -iE 'vga|3d|display'
}
alias ls-gpu='get_video_controller'

get_monitors() {
  if command -v xrandr >/dev/null 2>&1; then
    xrandr --listmonitors
  else
    echo xrandr not installed
  fi
}
alias ls-mons='get_monitors'

get_network_adapter_configuration() {
  if command -v nmcli >/dev/null 2>&1; then
    nmcli device show
  else
    ip addr
  fi
}
alias ls-net='get_network_adapter_configuration'

get_bios() {
  sudo dmidecode -t bios
}
alias ls-bios='get_bios'

get_ntlog_event() {
  journalctl
}
alias ls-logs='get_ntlog_event'

get_user_account() {
  getent passwd
}
alias ls-users='get_user_account'

get_computer_system() {
  uname -a
}
alias ls-host='get_computer_system'

get_group_user() {
  getent group
}
alias ls-groups='get_group_user'

get_operating_system() {
  if command -v lsb_release >/dev/null 2>&1; then
    lsb_release -a
  else
    hostnamectl
  fi
}
alias ls-os='get_operating_system'

get_product() {
  if command -v dpkg-query >/dev/null 2>&1; then
    dpkg-query -l
  elif command -v rpm >/dev/null 2>&1; then
    rpm -qa
  else
    echo "no package manager found"
  fi
}
alias ls-pkgs='get_product'

processor_data() {
  lscpu
}
alias cpu-info='processor_data'

ssram_data() {
  sudo dmidecode -t memory
}
alias ssram-info='ssram_data'

storage_data() {
  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
  df -h
}
alias storage-info='storage_data'

usb_data() {
  lsusb
}
alias usb-info='usb_data'

video_data() {
  lspci | grep -iE 'vga|3d|display'
}
alias video-info='video_data'

pnp_signed_driver() {
  if command -v lspci >/dev/null 2>&1; then
    lspci -k
  else
    echo "install pciutils"
  fi
}
alias pnp-info='pnp_signed_driver'

wddm_version() {
  if command -v glxinfo >/dev/null 2>&1; then
    glxinfo | grep "OpenGL version string"
  else
    echo "install mesa-utils"
  fi
}
alias wddm-info='wddm_version'

grouped_hardware() {
  if command -v lshw >/dev/null 2>&1; then
    sudo lshw -short
  else
    echo "install lshw"
  fi
}
alias lshw='grouped_hardware'

get_services() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl list-units --type=service --no-pager
  else
    service --status-all
  fi
}
alias ls-svc='get_services'

netsh_winsock_catalog() {
  ss -tunap
}
alias ls-sock='netsh_winsock_catalog'

netsh_wlan() {
  if command -v nmcli >/dev/null 2>&1; then
    nmcli device wifi list
  elif command -v iwlist >/dev/null 2>&1; then
    sudo iwlist scan
  else
    echo "no wireless tool available"
  fi
}
alias ls-wlan='netsh_wlan'

get_wireless_capabilities() {
  if command -v iw >/dev/null 2>&1; then
    iw list
  elif command -v nmcli >/dev/null 2>&1; then
    nmcli device wifi list
  else
    echo "install iw or NetworkManager to view wireless capabilities"
  fi
}
alias ls-wcap='get_wireless_capabilities'

get_net_drivers() {
  if command -v lspci >/dev/null 2>&1; then
    lspci -nnk | grep -A3 -i network
  else
    echo "install pciutils to list network drivers"
  fi
}
alias ls-netdrv='get_net_drivers'

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

compress_current_directory() {
  local zip_dest="$(basename "$(pwd)").zip"
  zip -r "$zip_dest" . -x "*/node_modules/*" "*/vendor/*"
  echo "Archive created: $zip_dest"
}
alias compdir='compress_current_directory'

unzip_all() {
  shopt -s globstar nocaseglob
  for f in **/*.zip **/*.7z **/*.rar; do
    d="${f%/*}"
    case "${f,,}" in
      *.zip) unzip -o "$f" -d "$d" ;;
      *.7z)  7z x "$f" -o"$d" ;;
      *.rar) unrar x "$f" "$d" ;;
    esac
  done
}
alias uz-all='unzip_all'

delete_all_compressed() {
  shopt -s nocaseglob
  rm -f *.zip *.7z *.rar
}
alias del-comp='delete_all_compressed'

convert_to_pascal_case() {
  local input="$1"
  local base="${input%_controller}"
  local pascal
  pascal=$(echo "$base" | sed -r 's/(^|_)([a-z])/\U\2/g')
  if [[ "$input" == *_controller ]]; then
    echo "${pascal}Controller"
  else
    echo "$pascal"
  fi
}
alias topascal='convert_to_pascal_case'

convert_to_snake_case() {
  local input="$1"
  local step
  step=$(echo "$input" | sed -r 's/([A-Z]+)([A-Z][a-z])/\1_\2/g')
  step=$(echo "$step"  | sed -r 's/([a-z0-9])([A-Z])/\1_\2/g')
  echo "${step,,}"
}
alias tosnake='convert_to_snake_case'

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
alias sanitize-d='sanitize_dirnames'

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
alias sanitize-f='sanitize_filenames'

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
alias sanitize-a='sanitize_names'

backup_robo() {
  local src=$1 dst=$2 retry=${3:-3} wait=${4:-5}
  for ((i=1; i<=retry; i++)); do
    rsync -a "$src" "$dst" && break || sleep "$wait"
  done
}
alias bcp='backup_robo'

heavy_folders() {
  local root=${1:-.} top=${2:-10}
  du -Sb "$root"/* 2>/dev/null \
    | sort -nr \
    | head -n "$top" \
    | awk '{printf "%.2fGB\t%s\n",$1/1024/1024/1024,$2}'
}
alias hfold='heavy_folders'

heavy_files() {
  local root=${1:-.} top=${2:-10}
  find "$root" -type f -printf '%s %p\n' 2>/dev/null \
    | sort -nr \
    | head -n "$top" \
    | awk '{printf "%.2fGB\t%s\n",$1/1024/1024/1024,substr($0,index($0,$2))}'
}
alias hfile='heavy_files'

du_surface() {
  local path=${1:-.}
  du -sh "$path"/* 2>/dev/null | sort -hr
}
alias du-surf='du_surface'

measure_file_distribution() {
  local root=$1 sub=$2 filter=${3:-*}
  [ ! -d "$root" ] && { echo "Root path not found"; return 1; }
  local root_count sub_count pct
  root_count=$(find "$root" -type f -name "$filter" 2>/dev/null | wc -l)
  echo "Found $root_count files in root folder"
  local sub_path="$root/$sub"
  [ ! -d "$sub_path" ] && { echo "Subdirectory '$sub' not found"; return 1; }
  sub_count=$(find "$sub_path" -type f -name "$filter" 2>/dev/null | wc -l)
  echo "Found $sub_count files in subfolder"
  pct=0
  [ "$root_count" -gt 0 ] && pct=$(awk -v s="$sub_count" -v r="$root_count" 'BEGIN{printf "%.2f", s/r*100}')
  printf "Root Files Count: %s\nNested Files Count: %s\nPercentage Nested: %s%%\nFilter Applied: %s\n" \
    "$root_count" "$sub_count" "$pct" "$filter"
}
alias mfd='measure_file_distribution'

search_interactive() {
  read -rp "Enter filename or pattern: " pattern
  local matches=()
  while IFS= read -r f; do
    echo "Looking at: $f"
    [[ "$(basename "$f")" == $pattern ]] && matches+=("$f")
  done < <(find . -type f)
  if [ ${#matches[@]} -gt 0 ]; then
    echo "Matches for '$pattern':"
    printf "%s\n" "${matches[@]}"
  else
    echo "No files found matching '$pattern'."
  fi
}
alias sint='search_interactive'

recursive_search_files() {
  local path=${1:-.} idx=${2:-1} filter=${3:-*}
  case "$idx" in
    0) find "$path" -type f -name "$filter" ;;
    1) find "$path" -type f -name "$filter" -printf '%f\n' ;;
    2) find "$path" -type f -name "$filter" -exec stat {} \; ;;
    *) echo "Index must be 0, 1 or 2" ;;
  esac
}
alias rsf='recursive_search_files'

cd_by_index() {
  local idx=${1:-0}
  mapfile -t dirs < <(printf "%s\n" */)
  [ ${#dirs[@]} -eq 0 ] && { echo "No directories found"; return 1; }
  if [ "$idx" -lt 0 ] || [ "$idx" -ge "${#dirs[@]}" ]; then
    echo "Index out of range. Available dirs:"
    for i in "${!dirs[@]}"; do printf "[%d] %s\n" "$i" "${dirs[i]}"; done
    return 1
  fi
  cd "${dirs[idx]}"
}
alias cd-i='cd_by_index'

expand_all_7z() {
  local path=${1:-.}
  shopt -s nullglob
  for f in "$path"/*.7z; do
    7z x "$f" -o"$path"
  done
}
alias exp-7z='expand_all_7z'

code_by_index() {
  local path=${1:-.} idx=${2:-0} files
  mapfile -t files < <(ls -1A "$path")
  if (( idx<0 || idx>=${#files[@]} )); then
    echo "Index out of range. Valid: 0 to $(( ${#files[@]} - 1 ))"
    for i in "${!files[@]}"; do printf "[%d] %s\n" "$i" "${files[i]}"; done
    return 1
  fi
  code "$path/${files[idx]}"
}
alias code-i='code_by_index'

open_with_excel() {
  local file=$1
  [[ -f "$file" ]] || { echo "Invalid path: $file"; return 1; }
  case "$file" in *.xls|*.xlsx|*.xlsm) ;; *) echo "Not an Excel file"; return 1;; esac
  command -v soffice >/dev/null 2>&1 && soffice --calc "$file" \
    || { echo "Please install libreoffice-calc"; return 1; }
}
alias xcl='open_with_excel'

get_concatenated_gpt_tokens() {
  local file=$1
  [[ -f "$file" ]] || { echo "Invalid path: $file"; return 1; }
  command -v jq >/dev/null 2>&1 || { echo "Please install jq"; return 1; }
  jq -r '.[] .data.v' "$file" | sed G
}
alias join-tokens='get_concatenated_gpt_tokens'

get_java_files_data() {
  local count=0 lines=0 f
  while IFS= read -r f; do
    echo "Found $f"
    count=$((count+1))
    lines=$((lines + $(wc -l < "$f")))
  done < <(find . -type f -name "*.java" 2>/dev/null)
  printf "Total Java Files: %d\nTotal Java Lines: %d\n" "$count" "$lines"
}
alias jdata='get_java_files_data'

get_js_files_data() {
  local count=0 lines=0 f
  while IFS= read -r f; do
    echo "Found $f"
    count=$((count+1))
    lines=$((lines + $(wc -l < "$f")))
  done < <(find . -type f \( -name "*.js" -o -name "*.cjs" -o -name "*.mjs" -o -name "*.jsx" -o -name "*.ts" -o -name "*.cts" -o -name "*.mts" -o -name "*.tsx" -o -name "*.vue" \) 2>/dev/null)
  printf "Total JS Files: %d\nTotal JS Lines: %d\n" "$count" "$lines"
}
alias jsdata='get_js_files_data'

get_php_files_data() {
  local count=0 lines=0 f
  while IFS= read -r f; do
    echo "Found $f"
    count=$((count+1))
    lines=$((lines + $(wc -l < "$f")))
  done < <(find . -type f -name "*.php" 2>/dev/null)
  printf "Total PHP Files: %d\nTotal PHP Lines: %d\n" "$count" "$lines"
}
alias phpdata='get_php_files_data'

get_python_files_data() {
  local count=0 lines=0 f
  while IFS= read -r f; do
    echo "Found $f"
    count=$((count+1))
    lines=$((lines + $(wc -l < "$f")))
  done < <(find . -type f -name "*.py" 2>/dev/null)
  printf "Total Python Files: %d\nTotal Python Lines: %d\n" "$count" "$lines"
}
alias pydata='get_python_files_data'

get_prog_lang_files_data() {
  local patterns=("$@") count=0 lines=0 f
  for p in "${patterns[@]}"; do
    while IFS= read -r f; do
      echo "Found $f"
      count=$((count+1))
      lines=$((lines + $(wc -l < "$f")))
    done < <(find . -type f -name "$p" 2>/dev/null)
  done
  printf "Total Files: %d\nTotal Lines: %d\n" "$count" "$lines"
}
alias pldata='get_prog_lang_files_data'

remove_multiple_underscores() {
  local path="${1:-.}" interactive=1
  [[ "$2" == "--no-interactive" ]] && interactive=0
  find "$path" -type f -name "*__*" | while IFS= read -r file; do
    local base="${file##*/}" dir="${file%/*}" newbase="${base//__/_}"
    if (( interactive )); then
      read -rp "Replace '$base' with '$newbase'? [y/N]: " resp
      [[ "$resp" =~ ^[Yy] ]] || { echo "Skipped"; continue; }
    fi
    mv -i "$file" "$dir/$newbase" && echo "Renamed '$base' → '$newbase'" || echo "Error renaming '$base'"
  done
}
alias rmmultius='remove_multiple_underscores'

clear_chrome_fetches() {
  local user_dir="${HOME}"
  # candidate Chrome cache paths
  local cache_dirs=(
    "$HOME/.cache/google-chrome/Default/Code Cache/entries"
    "$HOME/.cache/chromium/Default/Code Cache/entries"
  )
  for dir in "${cache_dirs[@]}"; do
    if [ -d "$dir" ]; then
      echo "Clearing Chrome fetches in $dir"
      rm -rf "${dir:?}"/*
    fi
  done
  echo "Chrome fetch cache cleared."
}
alias rm-chromefetch='clear_chrome_fetches'

# mysqlr() {
#   mysql -u root -p
# }
# alias mysqlr='mysqlr'

py_venv() {
  source ./env/bin/activate
}
alias py-venv='py_venv'

pymng() {
  command -v python >/dev/null 2>&1 || { echo "Python not found"; return 1; }
  [ ! -f manage.py ] && { echo "No manage.py found"; return 1; }
  python manage.py "$@"
  [ "$1" = runserver ] && echo "[Django] Server running. Press Ctrl+C to stop."
}
alias pymng='pymng'
alias django='pymng'

kill_chrome() {
  pkill -9 -f chrome 2>/dev/null || echo "No Chrome processes found"
  echo "Chrome processes terminated"
}
alias killchrome='kill_chrome'

clear_chrome_fetch() {
  local dirs=(
    "$HOME/.cache/google-chrome/Default/Code Cache/entries"
    "$HOME/.cache/chromium/Default/Code Cache/entries"
  )
  for d in "${dirs[@]}"; do
    [ -d "$d" ] && rm -rf "$d"/*
  done
  echo "Chrome fetch cache cleared"
}
alias rmchrome-fetch='clear_chrome_fetch'

list_heaviest_android_files() {
    local IGNORE_DIRS=(/system /vendor /proc /sys /dev /asec /acct /mnt /sys/fs /storage)
    local MAX_RESULTS=200
    local INTERIM_COUNT=50
    local REPORT_INTERVAL=100
    local temp_file
    temp_file=$(mktemp) || return 1

    generate_report() {
        sort -nrk1 "$1" |
        head -n "$2" |
        awk -F $'\t' '{ printf("%12d  %s\n", $1, $2) }'
    }

    countdown() {
        local sec=$1
        while (( sec > 0 )); do
            echo -ne "Resuming in $sec... (press C to pause) \r"
            read -rsn1 -t 1 key
            if [[ $key == [Cc] ]]; then
                echo -ne "\nPaused. Press C to resume.\n"
                while true; do
                    read -rsn1 key2
                    [[ $key2 == [Cc] ]] && break
                done
            fi
            (( sec-- ))
        done
        echo -ne "\r                                       \r"
    }

    local dirs=()
    while IFS= read -r -d '' dir; do
        local skip=false
        for ignore in "${IGNORE_DIRS[@]}"; do
            [[ "$dir" == "$ignore"* ]] && { skip=true; break; }
        done
        $skip || dirs+=("$dir")
    done < <(adb shell find / -type d -print0 2>/dev/null)

    local total=${#dirs[@]}
    local processed=0

    for dir in "${dirs[@]}"; do
        (( processed++ ))
        echo "[$processed/$total] Scanning: $dir"
        adb shell "find '$dir' -maxdepth 1 -type f -printf '%s\t%p\n'" 2>/dev/null >> "$temp_file"

        if (( processed % REPORT_INTERVAL == 0 )); then
            echo
            echo "Interim top $INTERIM_COUNT largest files so far:"
            generate_report "$temp_file" "$INTERIM_COUNT"
            echo
            countdown 5
            echo
        fi
    done

    echo
    echo "Final top $MAX_RESULTS largest files:"
    generate_report "$temp_file" "$MAX_RESULTS"
    rm -f "$temp_file"
}
alias ls-heavy-adb='list_heaviest_android_files'

list_heaviest_android_dirs() {
    local IGNORE_DIRS=(/system /vendor /proc /sys /dev /asec /acct /mnt /sys/fs /storage)
    local MAX_RESULTS=200 INTERIM_COUNT=50 REPORT_INTERVAL=100
    local temp_file dirs=() total processed key key2 sec

    temp_file=$(mktemp) || return 1

    generate_report() {
        sort -nrk1 "$1" | head -n "$2" | awk -F $'\t' '{printf("%12d  %s\n",$1,$2)}'
    }

    countdown() {
        sec=$1
        while (( sec > 0 )); do
            echo -ne "Resuming in $sec... (press C to pause) \r"
            read -rsn1 -t 1 key
            if [[ $key == [Cc] ]]; then
                echo -ne "\nPaused. Press C to resume.\n"
                while true; do
                    read -rsn1 key2
                    [[ $key2 == [Cc] ]] && break
                done
            fi
            (( sec-- ))
        done
        echo -ne "\r                                       \r"
    }

    while IFS= read -r -d '' dir; do
        skip=false
        for ignore in "${IGNORE_DIRS[@]}"; do
            [[ "$dir" == "$ignore"* ]] && { skip=true; break; }
        done
        $skip || dirs+=("$dir")
    done < <(adb shell find / -type d -print0 2>/dev/null)

    total=${#dirs[@]}
    processed=0

    for dir in "${dirs[@]}"; do
        (( processed++ ))
        echo "[$processed/$total] Measuring: $dir"
        adb shell du -s "$dir" 2>/dev/null | awk '{print $1"\t"$2}' >> "$temp_file"
        if (( processed % REPORT_INTERVAL == 0 )); then
            echo
            echo "Interim top $INTERIM_COUNT largest directories so far:"
            generate_report "$temp_file" "$INTERIM_COUNT"
            echo
            countdown 5
            echo
        fi
    done

    echo
    echo "Final top $MAX_RESULTS largest directories:"
    generate_report "$temp_file" "$MAX_RESULTS"
    rm -f "$temp_file"
}
alias ls-heavy-adb-dirs='list_heaviest_android_dirs'

# Complex Functions
alias tosnake='convert_to_snake_case'
alias compweb='compress_current_directory'
alias unzipall='unzip_all'
alias deletezip='delete_all_compressed'
alias getheavfiles='heavy_files'
alias getheavdirs='heavy_folders'
alias filedistrib='measure_file_distribution'
alias isearch='search_interactive'
alias lsrf='recursive_search_files'
alias idxcode='code_by_index'
alias getgpttokens='get_concatenated_gpt_tokens'
alias getjavadata='get_java_files_data'
alias getjsdata='get_js_files_data'
alias getphpdata='get_php_files_data'
alias getpydata='get_python_files_data'
alias getplngdata='get_prog_lang_files_data'

# Hardware
alias getprocfull='processor_data'
alias getssramfull='ssram_data'
alias getstoragefull='storage_data'
alias lshw-storage='storage_data'
alias getusbportfull='usb_data'
alias lsusb='usb_data'
alias getvcfull='video_data'
alias gethwfull='grouped_hardware'

# Storage
alias cbin='open_recycle_bin'

# USB
alias getusbcd='get_usb_controller_device'
alias getusbc='get_usb_controller'

# Proc & Mem
alias getproc='get_processor'
alias getpmem='get_physical_memory'
alias getdd='get_disk_drive'
alias getld='get_logical_disk'
alias getvc='get_video_controller'
alias getwddm='wddm_version'

# Core System
alias getbt='get_battery'
alias getpws='get_power_setting'
alias getprn='get_printers'
alias getbios='get_bios'
alias getcs='get_computer_system'
alias getos='get_operating_system'
alias getprod='get_product'
alias getsvc='get_services'

# Administration
alias getua='get_user_account'
alias getgu='get_group_user'
alias getntlog='get_ntlog_event'

# Network
alias getnac='get_network_adapter_configuration'
alias netshv='netsh_winsock_catalog'
alias netsha='netsh_wlan'
alias netshc='get_wireless_capabilities'
alias getndv='get_net_drivers'

# Quick Open
alias recyclebin='open_recycle_bin'
alias documents='open_documents'
alias docs='open_documents'
alias desktop='open_desktop'
alias dkt='open_desktop'
alias pictures='open_pictures'
alias pct='open_pictures'
alias memdiag='diagnose_memory'
alias fonts='open_fonts'
alias personalization='open_personalization'

# Settings
alias deb-st-display='xfce4-display-settings'
alias deb-st-nightlight='xfce4-power-manager-settings'
alias deb-st-screenresolution='xfce4-display-settings'
alias deb-st-multitasking='xfce4-workspace-settings'
alias deb-st-about='xfce4-about'
alias deb-st-systeminfo='xfce4-about'
alias deb-st-sound='pavucontrol'
alias deb-st-sound-devices='pavucontrol'
alias deb-st-audio='pavucontrol'
alias deb-st-network='nm-connection-editor'
alias deb-st-wifi='nm-connection-editor'
alias deb-st-ethernet='nm-connection-editor'
alias deb-st-bluetooth='blueman-manager'
alias deb-st-proxy='nm-connection-editor'
alias deb-st-personalization='xfce4-settings-manager'
alias deb-st-themes='xfce4-appearance-settings'
alias deb-st-colors='xfce4-appearance-settings'
alias deb-st-background='xfce4-desktop-settings'
alias deb-st-lockscreen='xfce4-screensaver-preferences'
alias deb-st-taskbar='xfce4-panel --preferences'
alias deb-st-fonts='xfce4-appearance-settings'
alias deb-st-cursormousepointer='xfce4-mouse-settings'
alias deb-st-printers='system-config-printer'
alias deb-st-mouse='xfce4-mouse-settings'
alias deb-st-touchpad='xfce4-mouse-settings'
alias deb-st-keyboard='xfce4-keyboard-settings'
alias deb-st-pen='xfce4-mouse-settings'
alias deb-st-autoplay='thunar --preferences'
alias deb-st-usb='thunar'
alias deb-st-dateandtime='xfce4-time-admin'
alias deb-st-regionlanguage='xfce4-settings-manager'
alias deb-st-language='xfce4-settings-manager'
alias deb-st-powersleep='xfce4-power-manager-settings'
alias deb-st-batterysaver='xfce4-power-manager-settings'
alias deb-st-poweroptions='xfce4-power-manager-settings'
alias deb-st-storagesense='thunar'
alias deb-st-defaultapps='xfce4-mime-settings'
alias deb-st-maps='xdg-open https://maps.google.com'
alias deb-st-appsfeatures='xfce4-appfinder'
alias deb-st-optionalfeatures='synaptic'
alias deb-st-programsfeatures='synaptic'
alias deb-st-defaultapps='xfce4-mime-settings'
alias deb-st-appdefaults='xfce4-mime-settings'
alias deb-st-yourinfo='users-admin'
alias deb-st-signinoptions='users-admin'
alias deb-st-workplace='users-admin'
alias deb-st-otherusers='users-admin'
alias deb-st-gaming='steam'
alias deb-st-gamemode='gamemode'
alias deb-st-easeofaccess='xfce4-accessibility-settings'
alias deb-st-display-easeofaccess='xfce4-display-settings'
alias deb-st-mousepointer='xfce4-mouse-settings'
alias deb-st-keyboard-easeofaccess='xfce4-keyboard-settings'
alias deb-st-privacy='xfce4-settings-manager'
alias deb-st-windowsdefender='clamav'
alias deb-st-backup='deja-dup'
alias deb-st-troubleshoot='xfce4-settings-manager'
alias deb-st-recovery='systemd-analyze'
alias deb-st-activation='xfce4-about'
alias deb-st-findmydevice='echo "Feature not available in Linux"'
alias deb-st-windowsupdate='sudo apt update && sudo apt upgrade'
alias deb-st-windowsdefender='sudo clamav-freshclam'
alias deb-st-backup='deja-dup-preferences'
alias deb-st-troubleshoot='xfce4-settings-manager'
alias deb-st-recovery='echo "Use GRUB recovery mode"'
alias deb-st-activation='echo "No activation needed in Linux"'
alias deb-st-developers='xfce4-settings-manager'
alias deb-st-cortana='xfce4-appfinder'
alias deb-st-search='xfce4-appfinder'
alias deb-st-holographic='echo "Mixed reality not natively supported"'
alias deb-st-explorer='thunar'
alias deb-st-thispc='thunar'
alias deb-st-documents='thunar ~/Documents'
alias deb-st-downloads='thunar ~/Downloads'
alias deb-st-music='thunar ~/Music'
alias deb-st-pictures='thunar ~/Pictures'
alias deb-st-videos='thunar ~/Videos'
alias deb-st-desktop='thunar ~/Desktop'
alias deb-st-controlpanel='xfce4-settings-manager'
alias deb-st-admintools='xfce4-settings-manager'
alias deb-st-devicemanager='lshw-gtk'
alias deb-st-diskmgmt='gnome-disks'
alias deb-st-eventvwr='gnome-logs'
alias deb-st-services='systemd-manager'
alias deb-st-taskmanager='htop'
alias deb-st-regedit='dconf-editor'
alias deb-st-terminal='xfce4-terminal'
alias deb-st-filemanager='thunar'
alias deb-st-calculator='galculator'
alias deb-st-notepad='mousepad'
alias deb-st-paint='gimp'
alias deb-st-screenshot='xfce4-screenshooter'
alias deb-st-msinfo32='hardinfo'
alias deb-st-msconfig='systemd-manager'
alias deb-st-cmd='xfce4-terminal'
alias deb-st-powershell='xfce4-terminal'
alias deb-st-run='xfce4-appfinder --collapsed'
alias ls-nomount='sudo blkid -o list | grep "not mounted"'
mount_ntfs_media_drive() {
    local media_path="$1"
    local device="$2"
    if [ -z "$media_path" ] || [ -z "$device" ]; then
       echo "Usage: mount_media_drive '/media/username/Drive Name' /dev/sdX1"
        echo "Example: mount_media_drive '/media/aronboliveira/Seagate Expansion Drive1' /dev/sdc1"
        return 1
    fi
    if [ ! -b "$device" ]; then
        echo "Error: Device $device does not exist"
        return 1
    fi
    sudo bash -c "
        set -e
        DEV='$device'
        M='$media_path'
        MPT=\$(findmnt -no TARGET \"\$DEV\" 2>/dev/null || true)
        [ -n \"\$MPT\" ] && umount \"\$MPT\" || true
        ntfsfix \"\$DEV\"
        mkdir -p \"\$M\"
        UUID=\$(blkid -s UUID -o value \"\$DEV\")
        M_ESC=\$(printf \"%s\" \"\$M\" | sed \"s/ /\\\\\\\\040/g\")
        LINE=\"UUID=\$UUID \$M_ESC ntfs uid=1000,gid=1000,dmask=022,fmask=133,windows_names,noatime,x-systemd.automount,nofail,x-systemd.device-timeout=5s 0 0\"
        sed -i.bak -e \"/UUID=\$UUID[[:space:]]/d\" -e \"\|[[:space:]]\$M_ESC[[:space:]]|d\" /etc/fstab
        printf \"%s\n\" \"\$LINE\" >> /etc/fstab
        systemctl daemon-reload
        mount -a
        ls \"\$M\" >/dev/null
        findmnt \"\$M\"
    "
}
alias mount-recover-ntfs='mount_ntfs_media_drive'
