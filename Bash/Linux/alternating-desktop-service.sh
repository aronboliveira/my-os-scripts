#!/bin/bash

ENCRYPTED_CIPHERDIR="$HOME/Pictures/wallpapers/.ld.cipherdir"
DECRYPTED_MOUNTPOINT="$HOME/Pictures/wallpapers/.ld"
GO_CRYPTFS_PASSWORD="YOUR_PASSWORD_HERE"

is_gocryptfs_mounted() {
    mountpoint -q "$DECRYPTED_MOUNTPOINT" 2>/dev/null
}

unmount_gocryptfs() {
    is_gocryptfs_mounted && fusermount -u "$DECRYPTED_MOUNTPOINT"
}

mount_gocryptfs() {
    is_gocryptfs_mounted && return 0
    [ ! -f "$ENCRYPTED_CIPHERDIR/gocryptfs.conf" ] && return 1
    mkdir -p "$DECRYPTED_MOUNTPOINT"
    echo "$GO_CRYPTFS_PASSWORD" | gocryptfs "$ENCRYPTED_CIPHERDIR" "$DECRYPTED_MOUNTPOINT" >/dev/null 2>&1
}

get_default_wallpaper() {
    local release=$(lsb_release -cs 2>/dev/null)
    case "$release" in
        jammy) echo "/usr/share/backgrounds/jammy-jellyfish-wallpaper.svg" ;;
        focal) echo "/usr/share/backgrounds/focal-fossa-wallpaper.svg" ;;
        bionic) echo "/usr/share/backgrounds/bionic-beaver-wallpaper.svg" ;;
        xenial) echo "/usr/share/backgrounds/xenial-xerus-wallpaper.svg" ;;
        *) 
            local default=$(find /usr/share/backgrounds -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.svg" \) 2>/dev/null | head -1)
            echo "${default:-/usr/share/backgrounds/gnome/adwaita-timed.xml}"
            ;;
    esac
}

# Returns random wallpaper from dir (excluding current), empty string on failure
try_set_wallpaper_from_dir() {
    local dir="$1"
    local current_uri="$2"
    
    echo "DEBUG: Trying directory: $dir" >&2
    
    [ ! -d "$dir" ] && echo "DEBUG: Directory does not exist" >&2 && return 1
    
    local files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.tiff" -o -iname "*.webp" -o -iname "*.svg" \) -print0 2>/dev/null)
    
    echo "DEBUG: Found ${#files[@]} image files" >&2
    [ ${#files[@]} -eq 0 ] && return 1
    
    local current_path="${current_uri#file://}"
    local available=()
    
    for file in "${files[@]}"; do
        [ "$file" != "$current_path" ] && available+=("$file")
    done
    
    [ ${#available[@]} -eq 0 ] && available=("${files[0]}")
    
    local random_index=$((RANDOM % ${#available[@]}))
    local selected="${available[$random_index]}"
    
    echo "DEBUG: Selected wallpaper: $selected" >&2
    
    if [[ "$(basename "$selected")" =~ _stretch\. ]]; then
        gsettings set org.gnome.desktop.background picture-options 'spanned'
    else
        gsettings set org.gnome.desktop.background picture-options 'zoom'
    fi
    
    gsettings set org.gnome.desktop.background picture-uri "file://$selected"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$selected"
    echo "$selected"
    return 0
}

# Returns random Yaru icon theme (excluding current)
get_random_icon_theme() {
    local current="$1"
    local themes=("Yaru-bark-dark" "Yaru-purple" "Yaru-viridian-dark" "Yaru-bark" 
                  "Yaru-magenta-dark" "Yaru-dark" "Yaru-blue-dark" "Yaru-magenta" 
                  "Yaru-red-dark" "Yaru-olive-dark" "Yaru-viridian" "Yaru-olive" 
                  "Yaru-blue" "Yaru-prussiangreen" "Yaru-prussiangreen-dark" "Yaru" 
                  "Yaru-purple-dark" "Yaru-sage-dark" "Yaru-red" "Yaru-sage")
    
    local available=()
    for theme in "${themes[@]}"; do
        [ "$theme" != "$current" ] && available+=("$theme")
    done
    
    [ ${#available[@]} -eq 0 ] && available=("${themes[@]}")
    
    echo "${available[$((RANDOM % ${#available[@]}))]}"
}

is_true() {
    [[ "${1,,}" =~ ^(1|y|yes|true)$ ]]
}

[ "${SHOULD_CHANGE_THEME:-1}" = "0" ] && exit 0

CURRENT_ICON_THEME=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
CURRENT_WALLPAPER=$(gsettings get org.gnome.desktop.background picture-uri | tr -d "'")
CURRENT_HOUR=$(date +%H | sed 's/^0//')
DAY_OF_WEEK=$(date +%u)

echo "=== DEBUG INFO ==="
echo "ALW_ALT_WP: '${ALW_ALT_WP}'"
echo "FORCE_FUN_WP: '${FORCE_FUN_WP}'"
echo "Current hour: $CURRENT_HOUR"
echo "Day of week: $DAY_OF_WEEK"
echo "Current wallpaper: $CURRENT_WALLPAPER"
echo "=================="

WALLPAPER=""
NEED_UNMOUNT=false

if is_true "${ALW_ALT_WP}"; then
    echo "Branch: ALW_ALT_WP is true"
    mount_gocryptfs && NEED_UNMOUNT=true
    WALLPAPER=$(try_set_wallpaper_from_dir "$DECRYPTED_MOUNTPOINT" "$CURRENT_WALLPAPER") || \
    WALLPAPER=$(try_set_wallpaper_from_dir "$HOME/Pictures/wallpapers/fun" "$CURRENT_WALLPAPER") || \
    WALLPAPER=$(try_set_wallpaper_from_dir "$HOME/Pictures/wallpapers/neutral" "$CURRENT_WALLPAPER")
elif is_true "${FORCE_FUN_WP}"; then
    echo "Branch: FORCE_FUN_WP is true"
    WALLPAPER=$(try_set_wallpaper_from_dir "$HOME/Pictures/wallpapers/fun" "$CURRENT_WALLPAPER") || \
    WALLPAPER=$(try_set_wallpaper_from_dir "$HOME/Pictures/wallpapers/neutral" "$CURRENT_WALLPAPER")
elif [ $DAY_OF_WEEK -le 5 ] && [ $CURRENT_HOUR -ge 6 ] && [ $CURRENT_HOUR -lt 18 ]; then
    echo "Branch: Workday hours"
    WALLPAPER=$(try_set_wallpaper_from_dir "$HOME/Pictures/wallpapers/neutral" "$CURRENT_WALLPAPER") || \
    WALLPAPER=$(try_set_wallpaper_from_dir "$HOME/Pictures/wallpapers/fun" "$CURRENT_WALLPAPER")
else
    echo "Branch: Non-workday hours"
    WALLPAPER=$(try_set_wallpaper_from_dir "$HOME/Pictures/wallpapers/fun" "$CURRENT_WALLPAPER") || \
    WALLPAPER=$(try_set_wallpaper_from_dir "$HOME/Pictures/wallpapers/neutral" "$CURRENT_WALLPAPER")
fi

if [ -z "$WALLPAPER" ]; then
    echo "All wallpaper attempts failed, using default"
    WALLPAPER=$(get_default_wallpaper)
    [ -n "$WALLPAPER" ] && gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER" &&
                           gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
fi

if [ $DAY_OF_WEEK -le 5 ] && [ $CURRENT_HOUR -ge 6 ] && [ $CURRENT_HOUR -lt 18 ]; then
    gsettings set org.gnome.desktop.interface icon-theme "$(get_random_icon_theme "$CURRENT_ICON_THEME")"
    gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
else
    gsettings set org.gnome.desktop.interface icon-theme 'luna'
    gsettings set org.gnome.desktop.interface cursor-theme 'standard-with-shadow'
fi

$NEED_UNMOUNT && unmount_gocryptfs

echo "Script completed"
