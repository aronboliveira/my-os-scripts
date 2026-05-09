  #region Utilities
    #region Package_Management
      alias prune-snap='sudo snap list --all | awk "/disabled/{print \$1, \$3}" | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done'
      ## @description Install Portuguese (pt) language packs (with confirmation).
      install_pt_lang_pack() {
        echo -e "\033[1;36m📦 This will install:\033[0m"
        echo "  • language-pack-pt"
        echo "  • language-pack-gnome-pt"
        read -rp "Proceed with installation? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[yY] ]]; then
          echo "Aborted."
          return 0
        fi
        sudo apt update -y && sudo apt install -y language-pack-pt language-pack-gnome-pt
      }
      alias install-pt-lang-pack='install_pt_lang_pack'
#endregion Package_Management

    #region Network_Monitoring
      ## BASED ON LUKE SMITH SCRIPT: https://www.youtube.com/watch?v=cvDyQUpaFf4
      cat_band() {
        init="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"
        printf "Recording bandwidth.. Press enter to stop."
        read -r "stop"
        fin="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"
        printf "%4sB of bandwith used.\\n" $(numfmt --to=iec $(($fin-$init)))
      }
      alias cat-band='cat_band'
#endregion Network_Monitoring

    #region Backup
      alias backup_projects='rsync -aHAXv --progress --checksum \
        --exclude="node_modules/" \
        --exclude="venv/" \
        --exclude=".venv/" \
        --exclude="__pycache__/" \
        --exclude=".gradle/" \
        --exclude=".m2/" \
        --exclude="vendor/" \
        --exclude="target/" \
        --exclude=".next/" \
        --exclude="dist/" \
        --exclude="build/"'
      alias backup-projects='backup_projects'
#endregion Backup

    #region File_Analysis
      ## @description Show recently used files from XDG recent files database.
      ## @param $1 {string} search_term - Optional filter pattern (default: ".")
      show_recent_files() {
        local search_term="${1:-.}"
        strings ~/.local/share/recently-used.xbel 2>/dev/null | \
          grep -o 'href="[^"]*"' | \
          sed 's/href="file:\/\///' | \
          sed 's/"//' | \
          while read line; do 
            echo "${line//\%/\\x}"
          done | \
          xargs -0 printf "%b" 2>/dev/null | \
          grep -i "$search_term"
      }
      alias ls-rec-files='show_recent_files'
      ## @description Check if a file has multiple consecutive blank lines.
      ## @param $1 {string} file - File path to check (required)
      has_multiple_blank_lines() {
        local file="$1"
        if [ ! -f "$file" ]; then
          echo "File not found: $file" >&2
          return 1
        fi
        awk '/^[[:space:]]*$/ {blank++} !/^[[:space:]]*$/ {if(blank>=2) exit 0; blank=0} END{exit !(blank>=2)}' "$file" && \
          echo "File does have multiple blank lines" || echo "File does not have multiple blank lines"
      }
      alias is-mblank='has_multiple_blank_lines'
      ## @description List files in current directory that have multiple consecutive blank lines.
      show_multiple_blank_lines_files() {
        find . -maxdepth 1 -type f -exec awk '
          /^[[:space:]]*$/ { blank++ }
          !/^[[:space:]]*$/ { 
            if (blank >= 2) { 
              print FILENAME ": has multiple consecutive blank lines"
              exit 
            }
            blank = 0 
          }
          END { 
            if (blank >= 2) 
              print FILENAME ": has multiple consecutive blank lines" 
          }
        ' {} \;
      }
      alias ls-mblank='show_multiple_blank_lines_files'
      ## @description List files with name, path, and size.
      list_files_detail() {
        find . -type f -exec sh -c '
          for file do
            basename=$(basename "$file")
            size=$(stat -c "%s" "$file")
            printf "NAME: %s  |  PATH: %s  |  SIZE: %s\n\n" "$basename" "$file" "$size"
          done
        ' sh {} +
      }
      alias list-files='list_files_detail'
      ## @description Check which directories in current dir contain files.
      ## @flag -r  Recurse into subdirectories
      contains_files() {
        local recurse=0
        [[ "$1" == "-r" ]] && recurse=1
        if (( recurse )); then
          find . -type d -exec sh -c '[ -n "$(find "$0" -maxdepth 1 -type f -print -quit)" ]' {} \; -print
        else
          find . -maxdepth 1 -type d -exec sh -c '[ -n "$(find "$0" -maxdepth 1 -type f -print -quit)" ]' {} \; -print
        fi
      }
      alias contains-files='contains_files'
#endregion File_Analysis

    #region Hardware_Shortcuts
      alias check-ecc='sudo dmidecode -t memory | grep -i "error\|ecc\|correction"'
      alias btctl='bluetoothctl'
      alias stctl='systemctl'
      alias su-stctl='sudo systemctl'
      alias disconnect-all-bt='for device in $(bluetoothctl devices Connected | awk '"'"'{print $2}'"'"'); do bluetoothctl disconnect "$device"; done'
    #endregion Hardware_Shortcuts

    #region Basic_Commands
      ## @description Open GNOME Text Editor.
      alias gted='gnome-text-editor'
      ## @description Short alias for rhythmbox-client.
      alias rtb='rhythmbox-client'
      ## @description Shuffle the Rhythmbox play order N times by toggling shuffle
      ##              off and back on so each iteration forces a fresh random sequence.
      ## @param $1 {number} times - Number of reshuffle iterations (default: 5)
      rtb_multishuffle() {
        local times="${1:-5}"
        local colors=(
          "1;31" "1;32" "1;33" "1;34" "1;35" "1;36"
          "1;91" "1;92" "1;93" "1;94" "1;95" "1;96"
        )
        for i in $(seq 1 "$times"); do
          local color="${colors[RANDOM % ${#colors[@]}]}"
          printf "\033[%sm ↻ Shuffling Rhythmbox ↺ (iteration %d/%d)…\033[0m\n" \
            "$color" "$i" "$times"
          rhythmbox-client --no-shuffle
          sleep 0.2
          rhythmbox-client --shuffle
          sleep 0.5
        done
        rhythmbox-client --play
      }
      ## @description Alias for rtb_multishuffle.
      alias rtb-mshuffle='rtb_multishuffle'
      ## @description Print D-Bus introspection XML for the Rhythmbox MPRIS2 interface.
      alias ls-mpris-dbus-sender='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.rhythmbox /org/mpris/MediaPlayer2 org.freedesktop.DBus.Introspectable.Introspect'
      ## @description Alias for ls-mpris-dbus-sender.
      alias show-mpris-dbus-sender='ls-mpris-dbus-sender'
      ## @description Alias for ls-mpris-dbus-sender.
      alias get-mpris-dbus-sender='ls-mpris-dbus-sender'
      alias mkd='mkdir'
      alias grep='grep --color=auto'
      alias wget-ubuntu-iso='wget https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-desktop-amd64.iso'
      ## @description Decode a percent-encoded URI string (e.g. %20 -> space).
      ## @param $1 {string} uri - Percent-encoded string to decode (required)
      uri_decode() {
          printf '%b' "${1//%/\\x}"
      }
      alias uri-decode='uri_decode'
      ## @description Printf with field-width, delimiter, and tr-based substitution.
      ## @param $1 {string} delimiter - Fill character flag (-, 0, +, or empty)
      ## @param $2 {number} width     - Field width
      ## @param $3 {string} type      - Format type (%b or %s, default: %b)
      ## @param $4 {string} target    - String to format (required)
      ## @param $5 {string} pattern   - Pattern to replace in target (required)
      ## @param $6 {string} substitute - Replacement string (required)
      ## @param $7 {string} tr_from   - tr source character (optional)
      ## @param $8 {string} tr_to     - tr destination character (optional, default: space)
      printftr() {
        local delimiter="${1:-}"
        local width="${2:-}"
        local type="${3:-%b}"
        local target="${4:?No argument for capturing provided}"
        local pattern="${5:?No pattern to replace provided. Failed.}"
        local substitute="${6:?No replacer given. Failed.}"
        local tr_from="${7:-}"
        local tr_to="${8:- }"
        if [[ -n "$delimiter" && "$delimiter" != '-' && "$delimiter" != '0' && "$delimiter" != '+' ]]; then
          echo "Invalid delimiter! Acceptable values are -, 0, + or empty" >&2
          return 1
        fi
        if [[ "$type" != '%b' && "$type" != '%s' ]]; then
          echo "Invalid type for printf. Acceptable values: %b or %s" >&2
          return 1
        fi
        local fill_char
        case "$delimiter" in
          '0') fill_char='0' ;;
          '+') fill_char='+' ;;
          *)   fill_char=' ' ;;
        esac
        tr_from="${tr_from:-$fill_char}"
        printf "%${delimiter}${width}${type#%}" "${target//${pattern}/${substitute}}" | tr "$tr_from" "$tr_to"
      }
      alias printf-tr='printftr'
      ## @description List files with index numbers and display the contents of a file by index.
      ## @param $1 {number} index - 1-based index of the file to display (default: 1)
      cat_indexed() {
        local index="${1:-1}"
        (ls | nl) && file=$(ls | sed -n "${index}p") && output=$(strings "$file") && echo "${output:-"INDEXED HAS NO CONTENT"} 2>/dev/null" || echo "No file found at index $index"
      }
      alias cat-indexed='cat_indexed'
      ## @description Run multiple commands against a single target argument.
      ## @param $1 {string} target - The target argument for all commands (required)
      ## @param $@ {string} cmds   - Commands to run against the target
      run_cmds() {
        [ -z "$1" ] && { echo "Error: target required" >&2; return 1; }
        local target="$1"
        shift
        for cmd in "$@"; do 
            eval "$cmd \"$target\"" 2>/dev/null
        done
      }
      alias run-cmds='run_cmds'
      ## @description Custom ls output: time, size, name.
      ls_lah_859() {
        local path="${1:-.}"
        ls -lah "$path" | awk 'BEGIN{FS=" "}; {print $8, $5, $9}'
      }
      alias ls-lah-859='ls_lah_859'
      ## @description Count total lines in directory excluding vendor folders.
      wc_lines_novendors() {
        local files=0 total=0
        while IFS= read -r -d $'\0' file; do
          lines=$(wc -l < "$file")
          total=$((total+lines))
          files=$((files+1))
          printf "%s %d\n" "$file" "$total"
        done < <(find . -type f \
              ! -path '*/vendor/*' \
              ! -path '*/node_modules/*' \
              ! -path '*/.git/*' \
              -print0)
        echo "-> TOTAL: $total lines in $files files"
      }
      alias wc-l-novendors='wc_lines_novendors'
      ## @description List block devices that are not mounted.
      alias ls-nomount='sudo blkid -o list | grep "not mounted"'
      ## @description Mount NTFS drive with proper options and add to fstab.
      ## @param $1 {string} media_path - Mount destination path (required)
      ## @param $2 {string} device - Block device path (required)
      mount_ntfs_media_drive() {
        local media_path="$1"
        local device="$2"
        if [ -z "$media_path" ] || [ -z "$device" ]; then
          echo "Usage: mount-recover-ntfs '/media/user/Drive Name' /dev/sdX1"
          echo "Example: mount-recover-ntfs '/media/aronboliveira/Seagate Expansion Drive1' /dev/sdc1"
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
          sed -i.bak -e \"/UUID=\$UUID[[:space:]]/d\" -e \"\|[[:space:]]\$M_ESC[[:space:]]\|d\" /etc/fstab
          printf \"%s\\n\" \"\$LINE\" >> /etc/fstab
          systemctl daemon-reload
          mount -a
          ls \"\$M\" >/dev/null
          findmnt \"\$M\"
        "
      }
      alias mount-recover-ntfs='mount_ntfs_media_drive'

      # sda2 is plain ext4 — no LUKS unlock needed (use mount-sda2 directly)
      alias mount-sda2='\
          sudo mkdir -p /mnt/sda2; \
          sudo mount /dev/sda2 /mnt/sda2; \
          echo "Successfully mounted /dev/sda2 to /mnt/sda2";'

      ## @description Calculate Modulus N check digits for a numeric string (e.g. CPF mod-11, CNPJ).
      ## @param $1 {string} state - Digit string (e.g. "123456789")
      ## @param $2 {number} total - Modulus base (e.g. 11)
      calculate_check_sum() {
        local state="${1:?Usage: calculate_check_sum <digits> <modulus>}"
        local total="${2:?Usage: calculate_check_sum <digits> <modulus>}"
        if ! [[ "$state" =~ ^[0-9]+$ ]]; then
          echo "Error: state must be a numeric string." >&2
          return 1
        fi
        if ! [[ "$total" =~ ^[0-9]+$ ]] || (( total < 2 )); then
          echo "Error: total must be an integer >= 2." >&2
          return 1
        fi
        local state_len=${#state}
        local diff=$(( total - state_len ))
        if (( diff < 1 )); then
          echo "Error: total must be greater than the length of state." >&2
          return 1
        fi
        local pos
        for (( pos = 1; pos <= diff; pos++ )); do
          local cur_len=$(( state_len + pos - 1 ))
          local sr=0 i
          for (( i = 0; i < cur_len; i++ )); do
            local digit="${state:$i:1}"
            local weight=$(( state_len + pos - i ))
            sr=$(( sr + digit * weight ))
          done
          local rest=$(( sr % total ))
          local check_digit
          if (( rest < 2 )); then
            check_digit=0
          else
            check_digit=$(( total - rest ))
          fi
          state="${state}${check_digit}"
        done
        echo "$state"
      }
      alias calculate-check-sum='calculate_check_sum'
      alias calc-checksum='calculate_check_sum'
      ## @description Change directory up N levels using dots or .{N}.
      ## @param $1 {string} dots - Dot pattern (e.g., ... or .{3})
      cdup() {
        if [[ $# -ne 1 ]]; then
          echo "Usage: cdup .... | cdup .{N}" >&2
          return 1
        fi
        local arg="$1"
        local n=""
        if [[ "$arg" =~ ^\.+$ ]]; then
          n=${#arg}
        elif [[ "$arg" =~ ^\.\{([0-9]+)\}$ ]]; then
          n="${BASH_REMATCH[1]}"
        else
          echo "Usage: cdup .... | cdup .{N}" >&2
          return 1
        fi
        if (( n < 1 )); then
          echo "Error: N must be >= 1" >&2
          return 1
        fi
        local path=""
        local i
        for (( i = 0; i < n; i++ )); do
          path+="../"
        done
        path="${path%/}"
        cd "$path" || return
      }
        ## @description Find common web image formats in a directory (png/jpg/gif/svg/webp/etc).
        ## @param $1 {string} path - Directory to search (default: .)
        ## @param $@ {string[]} extra - Additional find arguments
        find_web_images() {
          local path="${1:-.}"
          if [[ ! -d "$path" ]]; then
          echo "Error: $path is not a directory" >&2
          return 1
          fi
          find "$path" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o \
                    -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o \
                    -name "*.avif" -o -name "*.bmp" -o -name "*.ico" -o \
                    -name "*.tiff" -o -name "*.tif" \) "${@:2}"
        }
        ## @description Alias for find-web-images.
        alias ls-web-images='find_web_images'
        ## @description Alias for find-web-images.
        alias show-web-images='find_web_images'
        ## @description Find a broad set of image formats (web + RAW + design files).
        ## @param $1 {string} path - Directory to search (default: .)
        ## @param $@ {string[]} extra - Additional find arguments
        find_all_images() {
          local path="${1:-.}"
          if [[ ! -d "$path" ]]; then
          echo "Error: $path is not a directory" >&2
          return 1
          fi
          find "$path" -type f \( \
            -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o \
            -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o \
            -name "*.avif" -o -name "*.bmp" -o -name "*.ico" -o \
            -name "*.tiff" -o -name "*.tif" -o -name "*.jfif" -o \
            -name "*.jpe" -o -name "*.jif" -o -name "*.jp2" -o \
            -name "*.j2k" -o -name "*.jpf" -o -name "*.jpx" -o \
            -name "*.jpm" -o -name "*.mj2" -o -name "*.cr2" -o \
            -name "*.cr3" -o -name "*.nef" -o -name "*.nrw" -o \
            -name "*.arw" -o -name "*.srf" -o -name "*.sr2" -o \
            -name "*.orf" -o -name "*.rw2" -o -name "*.pef" -o \
            -name "*.ptx" -o -name "*.raf" -o -name "*.3fr" -o \
            -name "*.fff" -o -name "*.dcr" -o -name "*.dng" -o \
            -name "*.mrw" -o -name "*.iiq" -o -name "*.kdc" -o \
            -name "*.mos" -o -name "*.erf" -o -name "*.bay" -o \
            -name "*.psd" -o -name "*.psb" -o -name "*.ai" -o \
            -name "*.eps" -o -name "*.indd" -o -name "*.xcf" -o \
            -name "*.cdr" -o -name "*.heic" -o -name "*.heif" -o \
            -name "*.jxr" -o -name "*.jxl" \
          \) "${@:2}"
        }
        ## @description Alias for find-all-images.
        alias ls-all-images='find_all_images'
        ## @description Alias for find-all-images.
        alias show-all-images='find_all_images'
        ## @description Parse common find options for deep image search helpers.
        parse_find_options() {
          local path="."
          local max_depth=""
          local min_depth="0"
          local args=()
          while [[ $# -gt 0 ]]; do
            case "$1" in
              --path|-p)
                path="$2"
                shift 2
                ;;
              --max-depth|-M)
                max_depth="$2"
                shift 2
                ;;
              --min-depth|-m)
                min_depth="$2"
                shift 2
                ;;
              --help|-h)
                echo "Usage: ${FUNCNAME[1]} [OPTIONS] [-- extra find args]"
                echo "Options:"
                echo "  --path, -p DIR     Directory to search (default: .)"
                echo "  --max-depth, -M N  Maximum depth (default: no limit)"
                echo "  --min-depth, -m N  Minimum depth (default: 0)"
                echo "  --help, -h         Show this help"
                echo "All remaining arguments are passed directly to find."
                return 1
                ;;
              --)
                shift
                args+=("$@")
                break
                ;;
              -*)
                args+=("$@")
                break
                ;;
              *)
                if [[ "$path" == "." ]]; then
                  path="$1"
                  shift
                else
                  args+=("$@")
                  break
                fi
                ;;
            esac
          done
          if [[ ! -d "$path" ]]; then
            echo "Error: '$path' is not a directory" >&2
            return 1
          fi
          FIND_OPTS_PATH="$path"
          FIND_OPTS_MIN="$min_depth"
          FIND_OPTS_MAX="$max_depth"
          FIND_OPTS_ARGS=("${args[@]}")
          return 0
        }
        ## @description Find common web image formats with depth controls.
        find_web_images_deep() {
          parse_find_options "$@" || return 1
          local cmd=(find "$FIND_OPTS_PATH" -type f)
          if [[ -n "$FIND_OPTS_MIN" && "$FIND_OPTS_MIN" != "0" ]]; then
          cmd+=( -mindepth "$FIND_OPTS_MIN" )
          fi
          if [[ -n "$FIND_OPTS_MAX" ]]; then
          cmd+=( -maxdepth "$FIND_OPTS_MAX" )
          fi
          cmd+=( \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o \
                -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o \
                -name "*.avif" -o -name "*.bmp" -o -name "*.ico" -o \
                -name "*.tiff" -o -name "*.tif" \) )
          cmd+=( "${FIND_OPTS_ARGS[@]}" )
          "${cmd[@]}"
        }
        ## @description Alias for find-web-images-deep.
        alias ls-web-images-deep='find_web_images_deep'
        ## @description Alias for find-web-images-deep.
        alias show-web-images-deep='find_web_images_deep'
        ## @description Find a broad set of image formats with depth controls.
        find_all_images_deep() {
          parse_find_options "$@" || return 1
          local cmd=(find "$FIND_OPTS_PATH" -type f)
          if [[ -n "$FIND_OPTS_MIN" && "$FIND_OPTS_MIN" != "0" ]]; then
          cmd+=( -mindepth "$FIND_OPTS_MIN" )
          fi
          if [[ -n "$FIND_OPTS_MAX" ]]; then
          cmd+=( -maxdepth "$FIND_OPTS_MAX" )
          fi
          cmd+=( \( \
            -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o \
            -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o \
            -name "*.avif" -o -name "*.bmp" -o -name "*.ico" -o \
            -name "*.tiff" -o -name "*.tif" -o -name "*.jfif" -o \
            -name "*.jpe" -o -name "*.jif" -o -name "*.jp2" -o \
            -name "*.j2k" -o -name "*.jpf" -o -name "*.jpx" -o \
            -name "*.jpm" -o -name "*.mj2" -o -name "*.cr2" -o \
            -name "*.cr3" -o -name "*.nef" -o -name "*.nrw" -o \
            -name "*.arw" -o -name "*.srf" -o -name "*.sr2" -o \
            -name "*.orf" -o -name "*.rw2" -o -name "*.pef" -o \
            -name "*.ptx" -o -name "*.raf" -o -name "*.3fr" -o \
            -name "*.fff" -o -name "*.dcr" -o -name "*.dng" -o \
            -name "*.mrw" -o -name "*.iiq" -o -name "*.kdc" -o \
            -name "*.mos" -o -name "*.erf" -o -name "*.bay" -o \
            -name "*.psd" -o -name "*.psb" -o -name "*.ai" -o \
            -name "*.eps" -o -name "*.indd" -o -name "*.xcf" -o \
            -name "*.cdr" -o -name "*.heic" -o -name "*.heif" -o \
            -name "*.jxr" -o -name "*.jxl" \
          \) )
          cmd+=( "${FIND_OPTS_ARGS[@]}" )
          "${cmd[@]}"
        }
        ## @description Alias for find-all-images-deep.
        alias ls-all-images-deep='find_all_images_deep'
        ## @description Alias for find-all-images-deep.
        alias show-all-images-deep='find_all_images_deep'
#endregion Basic_Commands
  #endregion Utilities

