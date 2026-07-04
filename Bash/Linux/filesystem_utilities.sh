  #region Filesystem_Utilities
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

    ## @description View or edit the X11 Compose key character definitions.
    alias cat-compose-chars='sudo cat /usr/share/X11/locale/en_US.UTF-8/Compose'
    ## @description Alias for cat-compose-chars.
    alias show-compose-chars='sudo cat /usr/share/X11/locale/en_US.UTF-8/Compose'
    alias ls-compose-chars='cat-compose-chars'
    alias less-compose-chars='sudo less /usr/share/X11/locale/en_US.UTF-8/Compose'
    alias edit-compose-chars='sudo nano /usr/share/X11/locale/en_US.UTF-8/Compose'

    ## @description Find and sort files by path length, excluding vendor/node_modules/backup directories.
    ## @param $1 {string} extension - File extension pattern to match (required)
    ## @param $2 {string} src - Root search directory (default: .)
    ## @param $3 {int} max_depth - Max directory depth (default: 15)
    ## @param $4 {int} cut_indexes - If non-zero, strip path-length prefix from output (default: 0)
    function list_paths_no_vendors() {
      local extension=${1?Usage: find-sorted-paths-no-vendors <extension> ?<src=.> ?<max_depth=15> ?<cut_indexes=0>}
      local src=${2:-.}
      local max_depth=${3:-15}
      local cut_indexes=${4:-0}
      local sorted_res=$(find "$src" -maxdepth "$max_depth" -type f \( -not -path "*node_modules*" -not -path "*/vendor/*" -not -path "*backup/*" -not -path "*.venv/" -path "*${extension}" \) | awk '{print length,$0}' | sort -n -k1,1 -k2)
      if (( ! cut_indexes == 0 )); then
        sorted_res=$(echo "$sorted_res" | cut -d' ' -f2-)
      fi
      echo "$sorted_res"
    }
    alias list-paths-no-vendors='list_paths_no_vendors'
    ls_journal_files() {
      local path="/var/log/journal"
      if [[ ! -d "$path" ]]; then
        echo "Error: $path is not a directory" >&2
        return 1
      fi
      sudo find "$path" -type f -print0 2>/dev/null | while IFS= read -r -d '' file; do
        echo -e "\n"
        sudo file "$file" | sed "s|$path/||"
        sudo du -h "$file" | awk '{print $1}'
        if file -b --mime-encoding "$file" 2>/dev/null | grep -qi "binary"; then
          echo -e "⚠️  (binary — showing printable strings)"
          sudo strings "$file" 2>/dev/null | head -n 5
        fi
        echo -e "\n"
      done
    }
    alias ls-journal-files='ls_journal_files'
    alias show-journal-files='ls_journal_files'

#endregion Filesystem_Utilities
