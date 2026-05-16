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
      cleanup_before_sync() {
          local SRC="$1"
          local DST="$2"
          [ -d "$SRC" ] || { echo "Source not found: $SRC" >&2; return 1; }
          [ -d "$DST" ] || return 0
          local TRASH="${DST}/.trashed"
          mkdir -p "$TRASH"
          local tmpfile
          tmpfile=$(mktemp) || return 1
          local rsync_out deletions=()
          # Leading / anchors exclude to transfer root — only the top-level .trashed/
          rsync -ain --delete --out-format='%i %n' --exclude='/.trashed/' \
              "$SRC/" "$DST/" 2>/dev/null >"$tmpfile"
          local rsync_rc=$?
          # 23=partial transfer OK, 24=source files vanished OK
          if [ $rsync_rc -ne 0 ] && [ $rsync_rc -ne 23 ] && [ $rsync_rc -ne 24 ]; then
              rm -f "$tmpfile"
              echo "cleanup: rsync failed (exit $rsync_rc), aborting" >&2
              return 1
          fi
          mapfile -t rsync_out <"$tmpfile"
          rm -f "$tmpfile"
          local line relpath dst_item trash_item ts count=0
          declare -A moved_ancestors
          for line in "${rsync_out[@]}"; do
              [[ "$line" == \*deleting* ]] || continue
              relpath="${line#\*deleting }"
              relpath="${relpath%/}"
              [ -z "$relpath" ] && continue
              dst_item="$DST/$relpath"
              # Skip if we already moved an ancestor directory containing this item
              local ancestor="$relpath"
              while [[ "$ancestor" == */* ]]; do
                  ancestor="${ancestor%/*}"
                  [ -n "${moved_ancestors[$ancestor]:-}" ] && continue 2
              done
              [ -e "$dst_item" ] || continue
              trash_item="$TRASH/$relpath"
              mkdir -p "$(dirname "$trash_item")"
              if [ -e "$trash_item" ]; then
                  trash_item="${trash_item}.bak.$(date +%s%N)"
              fi
              mv "$dst_item" "$trash_item" && {
                  count=$((count + 1))
                  [ -d "$trash_item" ] && moved_ancestors[$relpath]=1
              }
          done
          [ "$count" -gt 0 ] && echo "cleanup: $count orphaned items moved to $TRASH"
          return 0
      }
      run_backup_projects() {
        local src="${1:?Usage: run_backup_projects <source_dir> <dest_dir>}"
        local dest="${2:?Usage: run_backup_projects <source_dir> <dest_dir>}"
        rsync -aHAXv --progress --checksum \
          --exclude={node_modules/,venv/,.venv/,__pycache__/,.gradle/,.m2/,vendor/,target/,.next/,dist/,build/,.docker/,docker/volumes/,docker/data/} \
          "$src" "$dest"
      }
      alias backup_projects='rsync -aHAXv --progress --checksum \
        --exclude={node_modules/,venv/,.venv/,__pycache__/,.gradle/,.m2/,vendor/,target/,.next/,dist/,build/,.docker/,docker/volumes/,docker/data/}'
      alias backup-projects='backup_projects'
      ## @description Forensic scan of a Chromium-based browser profile for download
      ## @description traces of a given file format. Runs every query class used during
      ## @description the May 15 music-recovery session: History DB (downloads table,
      ## @description downloads_url_chains, urls, visits, Cookies), per-site IndexedDB,
      ## @description Local/Session Storage strings dumps, and recently-used.xbel.
      ## @description Prints a categorized summary, optionally cross-checks against the
      ## @description filesystem with `find`, and optionally hands off to
      ## @description recover_chromium_yt_downloads_by_traces for re-download.
      ## @param $1 {string} format          - File extension to search for, e.g. mp3, webm, m4a (MANDATORY)
      ## @flag -b, --browser <name>         Chromium variant: brave (default), chromium, chrome, edge, vivaldi, opera
      ## @flag -p, --profile <name>         Profile directory name (default: Default)
      ## @flag -d, --days <N>               Lookback window in days (default: since browser install)
      ## @flag --filter-existing            After scan, run `find` to drop entries that already exist locally
      ## @flag --redownload                 If any traces look YouTube-shaped, prompt to call recover_chromium_yt_downloads_by_traces
      ## @flag --search-root <dir>          Root for the existing-file `find` (default: $HOME and /media)
      ## @flag -h, --help                   Show usage
      search_chromium_download_traces() {
        local format="" browser="brave" profile="Default" days="" filter_existing=0 redownload=0
        local -a search_roots=("$HOME" "/media" "/mnt")
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -b|--browser)         browser="$2"; shift 2 ;;
            -p|--profile)         profile="$2"; shift 2 ;;
            -d|--days)            days="$2"; shift 2 ;;
            --filter-existing)    filter_existing=1; shift ;;
            --redownload)         redownload=1; shift ;;
            --search-root)        search_roots=("$2"); shift 2 ;;
            -h|--help)
              echo -e "📖 \033[1msearch_chromium_download_traces\033[0m <format> [-b brave|chromium|chrome|edge|vivaldi|opera] [-p <profile>] [-d <days>] [--filter-existing] [--redownload]"
              return 0 ;;
            -*) echo -e "❌ Unknown flag: $1"; return 1 ;;
            *)  [ -z "$format" ] && format="$1" || { echo -e "❌ Unexpected arg: $1"; return 1; }; shift ;;
          esac
        done
        if [ -z "$format" ]; then
          echo -e "❌ Usage: search_chromium_download_traces <format> [...]"
          return 1
        fi
        format="${format#.}"

        # ---- browser → (config-dir, binary candidates) registry
        declare -A BROWSER_DIRS=(
          [brave]="$HOME/.config/BraveSoftware/Brave-Browser"
          [chromium]="$HOME/.config/chromium"
          [chrome]="$HOME/.config/google-chrome"
          [edge]="$HOME/.config/microsoft-edge"
          [vivaldi]="$HOME/.config/vivaldi"
          [opera]="$HOME/.config/opera"
        )
        declare -A BROWSER_BINS=(
          [brave]="brave brave-browser brave-browser-stable"
          [chromium]="chromium chromium-browser"
          [chrome]="google-chrome google-chrome-stable"
          [edge]="microsoft-edge microsoft-edge-stable"
          [vivaldi]="vivaldi vivaldi-stable"
          [opera]="opera"
        )
        _is_installed() {
          local key="$1" b
          for b in ${BROWSER_BINS[$key]}; do command -v "$b" >/dev/null 2>&1 && return 0; done
          [ -d "${BROWSER_DIRS[$key]}" ] && return 0
          return 1
        }
        echo -e "🔬 \033[1mPHASE 1\033[0m — Browser detection"
        echo -e "  Requested browser: \033[1m$browser\033[0m"
        echo -e "  Searching binaries: ${BROWSER_BINS[$browser]:-<none>}"
        echo -e "  Searching config dir: ${BROWSER_DIRS[$browser]:-<none>}"
        if ! _is_installed "$browser"; then
          echo -e "  ⚠️  \033[1;33m$browser is not installed.\033[0m"
          local -a avail=()
          for k in "${!BROWSER_DIRS[@]}"; do
            if _is_installed "$k"; then
              avail+=("$k")
              echo -e "    • $k found at ${BROWSER_DIRS[$k]}"
            fi
          done
          if [ "${#avail[@]}" -eq 0 ]; then
            echo -e "  ❌ No supported Chromium browser is installed."; return 1
          fi
          local pick
          read -rp "  Proceed with one of them? [name / n=cancel]: " pick
          if [[ " ${avail[*]} " =~ " $pick " ]]; then
            browser="$pick"
            echo -e "  ✅ Switched to: $browser"
          else
            echo -e "  ❌ Aborted."; return 1
          fi
        else
          echo -e "  ✅ Installed and config dir present."
        fi
        local cfg="${BROWSER_DIRS[$browser]}"
        local prof_dir="$cfg/$profile"
        echo -e "🔬 \033[1mPHASE 2\033[0m — Profile resolution"
        echo -e "  Profile name: \033[1m$profile\033[0m"
        echo -e "  Profile path: $prof_dir"
        if [ ! -d "$prof_dir" ]; then
          echo -e "  ❌ Profile not found."
          echo -n "  Available profiles: "; ls "$cfg" 2>/dev/null | grep -E "^(Default|Profile|Guest)" | tr '\n' ' '; echo
          return 1
        fi
        echo -e "  ✅ Profile directory readable."

        # ---- compute time window
        echo -e "🔬 \033[1mPHASE 3\033[0m — Time window resolution"
        local since_unix until_unix since_source
        until_unix=$(date +%s)
        if [ -n "$days" ]; then
          since_unix=$(( until_unix - days*86400 ))
          since_source="--days $days override"
        else
          since_unix=$(stat -c %Y "$cfg" 2>/dev/null || echo 0)
          since_source="mtime of $cfg (browser install/first-run proxy)"
        fi
        local since_chrome=$(( (since_unix + 11644473600) * 1000000 ))
        local until_chrome=$(( (until_unix + 11644473600) * 1000000 ))
        local since_iso=$(date -d "@$since_unix" '+%Y-%m-%d %H:%M:%S')
        local until_iso=$(date -d "@$until_unix" '+%Y-%m-%d %H:%M:%S')
        echo -e "  Since: $since_iso  ($since_source)"
        echo -e "  Until: $until_iso  (now)"
        echo -e "  Chrome epoch range: [$since_chrome, $until_chrome]"
        echo -e "  Format filter: \033[1m*.$format\033[0m"

        echo -e "🔍 \033[1;36mScanning $browser / $profile from $since_iso to $until_iso for *.$format\033[0m"
        local TMP
        TMP=$(mktemp -d)
        trap 'rm -rf "$TMP"' RETURN

        # =========================================================================
        # QUERY CLASS 1 — History.downloads (final filename, MIME, state, start_time)
        # =========================================================================
        echo -e "\n🔬 \033[1mPHASE 4 / Query 1\033[0m — History.downloads (Chromium download manager records)"
        echo -e "  Source: $prof_dir/History  (SQLite)"
        echo -e "  Tables: downloads JOIN downloads_url_chains"
        echo -e "  Filter: target_path LIKE '%.$format' AND start_time in window"
        cp -f "$prof_dir/History" "$TMP/h.db" 2>/dev/null \
          && echo -e "  ✅ DB copied (live DB is locked while browser is open; we work on a snapshot)" \
          || echo -e "  ⚠️  Could not copy History DB"
        local q1="
          SELECT datetime(d.start_time/1000000 - 11644473600,'unixepoch','localtime') AS ts,
                d.target_path, d.mime_type, d.state,
                (SELECT u.url FROM downloads_url_chains u WHERE u.id=d.id ORDER BY u.chain_index DESC LIMIT 1) AS final_url,
                (SELECT u.url FROM downloads_url_chains u WHERE u.id=d.id ORDER BY u.chain_index ASC LIMIT 1)  AS first_url,
                d.referrer, d.tab_url
          FROM downloads d
          WHERE d.start_time BETWEEN $since_chrome AND $until_chrome
            AND LOWER(d.target_path) LIKE '%.$format'
          ORDER BY d.start_time ASC;"
        local Q1_OUT="$TMP/q1.txt"; sqlite3 "$TMP/h.db" "$q1" > "$Q1_OUT" 2>/dev/null
        echo -e "  → $(grep -c . "$Q1_OUT" 2>/dev/null || echo 0) records"

        # =========================================================================
        # QUERY CLASS 2 — History.visits + History.urls (referrers to converter sites
        # and to YouTube searches that match the format we're after)
        # =========================================================================
        local converter_pat="orangemp3|ytmp3|y2mate|savefrom|freeconvert|cnvmp3|mp3juices|flvto|2conv|320ytmp3|320kbpsmp3"
        local q2="
          SELECT datetime(v.visit_time/1000000 - 11644473600,'unixepoch','localtime') AS ts, u.url, u.title
          FROM visits v JOIN urls u ON v.url=u.id
          WHERE v.visit_time BETWEEN $since_chrome AND $until_chrome
            AND (u.url REGEXP '$converter_pat' OR u.title LIKE '%$format%' OR u.url LIKE '%search_query%')
          ORDER BY ts;"
        echo -e "\n🔬 \033[1mQuery 2\033[0m — History.visits + History.urls (converter/search visits)"
        echo -e "  Tables: visits JOIN urls"
        echo -e "  Filter: url LIKE any-of {orangemp3, ytmp3, y2mate, savefrom, freeconvert, cnvmp3, mp3juices, flvto, search_query}"
        local Q2_OUT="$TMP/q2.txt"
        sqlite3 "$TMP/h.db" "SELECT load_extension('/usr/lib/sqlite3/pcre.so');" 2>/dev/null
        sqlite3 "$TMP/h.db" "
          SELECT datetime(v.visit_time/1000000 - 11644473600,'unixepoch','localtime') AS ts, u.url, u.title
          FROM visits v JOIN urls u ON v.url=u.id
          WHERE v.visit_time BETWEEN $since_chrome AND $until_chrome
            AND (u.url LIKE '%orangemp3%' OR u.url LIKE '%ytmp3%' OR u.url LIKE '%y2mate%'
              OR u.url LIKE '%savefrom%' OR u.url LIKE '%freeconvert%' OR u.url LIKE '%cnvmp3%'
              OR u.url LIKE '%mp3juices%' OR u.url LIKE '%flvto%' OR u.url LIKE '%search_query%')
          ORDER BY ts;" > "$Q2_OUT" 2>/dev/null
        echo -e "  → $(grep -c . "$Q2_OUT" 2>/dev/null || echo 0) records"

        # =========================================================================
        # QUERY CLASS 3 — Cookies for converter / YouTube hosts (presence == used)
        # =========================================================================
        echo -e "\n🔬 \033[1mQuery 3\033[0m — Cookies for converter/YouTube hosts (presence implies a visit)"
        echo -e "  Source: $prof_dir/Cookies  (SQLite)"
        local Q3_OUT="$TMP/q3.txt"
        if cp -f "$prof_dir/Cookies" "$TMP/c.db" 2>/dev/null; then
          echo -e "  ✅ Cookies DB copied"
          sqlite3 "$TMP/c.db" "
            SELECT host_key, name, datetime(creation_utc/1000000 - 11644473600,'unixepoch') AS created
            FROM cookies
            WHERE host_key LIKE '%orangemp3%' OR host_key LIKE '%ytmp3%' OR host_key LIKE '%y2mate%'
              OR host_key LIKE '%savefrom%' OR host_key LIKE '%freeconvert%' OR host_key LIKE '%cnvmp3%'
              OR host_key LIKE '%mp3juices%' OR host_key LIKE '%youtube%';" > "$Q3_OUT" 2>/dev/null
        else
          echo -e "  ⚠️  Could not copy Cookies DB"
        fi
        echo -e "  → $(grep -c . "$Q3_OUT" 2>/dev/null || echo 0) cookies"

        # =========================================================================
        # QUERY CLASS 4 — IndexedDB strings dump for per-site converters AND YouTube
        # (YouTube's playback telemetry stores docid + list + referrer, which is how
        # we forensically resolved which playlist items were actually watched.)
        # =========================================================================
        echo -e "\n🔬 \033[1mQuery 4\033[0m — IndexedDB (LevelDB) strings dump per site"
        echo -e "  Source dirs: $prof_dir/IndexedDB/*"
        echo -e "  Targeted hosts: youtube, orangemp3, ytmp3, y2mate, savefrom, freeconvert, cnvmp3"
        echo -e "  Extracting: docid/list/referrer pairs (YT watch telemetry), search_query strings"
        local Q4_OUT="$TMP/q4.txt"
        : > "$Q4_OUT"
        for site_dir in "$prof_dir/IndexedDB"/*; do
          [ -d "$site_dir" ] || continue
          local site
          site=$(basename "$site_dir")
          case "$site" in
            *youtube*|*orangemp3*|*ytmp3*|*y2mate*|*savefrom*|*freeconvert*|*cnvmp3*)
              echo -e "  • probing: $site"
              echo "### IndexedDB site: $site ###" >> "$Q4_OUT"
              strings -n 6 "$site_dir"/*.{ldb,log} 2>/dev/null \
                | grep -oE "docid=[A-Za-z0-9_-]+[^\"]*?(list=[A-Za-z0-9_-]+|referrer=[^&\"]+)" \
                | sort -u >> "$Q4_OUT"
              strings -n 6 "$site_dir"/*.{ldb,log} 2>/dev/null \
                | grep -oE "search_query%3D[^&\"]+" | sort -u >> "$Q4_OUT"
              ;;
          esac
        done
        echo -e "  → $(grep -cE "^docid=|^search_query" "$Q4_OUT" 2>/dev/null || echo 0) extracted refs"

        # =========================================================================
        # QUERY CLASS 5 — Local Storage / Session Storage strings dump for hosts
        # that the user clearly used. Catches cached track titles dropped by
        # converter front-ends that store recent jobs in localStorage.
        # =========================================================================
        echo -e "\n🔬 \033[1mQuery 5\033[0m — Local Storage / Session Storage strings dump"
        echo -e "  Source: $prof_dir/Local Storage/leveldb and $prof_dir/Session Storage"
        echo -e "  Heuristic filters: site keywords, .${format}, videoId, title, search_query"
        local Q5_OUT="$TMP/q5.txt"
        : > "$Q5_OUT"
        for stor_root in "$prof_dir/Local Storage/leveldb" "$prof_dir/Session Storage"; do
          [ -d "$stor_root" ] || continue
          echo -e "  • probing: $stor_root"
          echo "### $stor_root ###" >> "$Q5_OUT"
          strings -n 8 "$stor_root"/*.{ldb,log} 2>/dev/null \
            | grep -iE "orangemp3|ytmp3|youtube|\.${format}\b|search_query|videoId|title" \
            | sort -u | head -80 >> "$Q5_OUT"
        done
        echo -e "  → $(grep -cE "." "$Q5_OUT" 2>/dev/null || echo 0) suggestive strings"

        # =========================================================================
        # QUERY CLASS 6 — recently-used.xbel (GNOME's app-opened-files index).
        # Browser-independent but it caught files the browser registry missed.
        # =========================================================================
        echo -e "\n🔬 \033[1mQuery 6\033[0m — recently-used.xbel (GNOME app-opened-files registry)"
        echo -e "  Sources: $HOME/.local/share/recently-used.xbel*"
        echo -e "  Filter: href=\"file://...\\.${format}\""
        local Q6_OUT="$TMP/q6.txt"
        : > "$Q6_OUT"
        for xbel in "$HOME"/.local/share/recently-used.xbel*; do
          [ -f "$xbel" ] || continue
          echo -e "  • probing: $(basename "$xbel")"
          grep -oE "href=\"file://[^\"]+\.${format}\"" "$xbel" 2>/dev/null \
            | sed -E 's/^href="file:\/\///;s/"$//' \
            | python3 -c "import sys, urllib.parse; [print(urllib.parse.unquote(l), end='') for l in sys.stdin]" \
            >> "$Q6_OUT"
        done
        echo -e "  → $(grep -c . "$Q6_OUT" 2>/dev/null || echo 0) .${format} paths"

        echo -e "\n🔬 \033[1mPHASE 5\033[0m — Consolidating traces (tagged by origin)"
        # ---- consolidated trace list (just basenames + their sources)
        local TRACES="$TMP/traces.txt"
        : > "$TRACES"
        awk -F'|' 'NF>=2 && $2!="" {print "[downloads]\t" $2}' "$Q1_OUT" >> "$TRACES"
        awk -F'\t' '{print "[xbel]\t" $0}' "$Q6_OUT" >> "$TRACES"
        # YouTube docids → reconstruct URLs the recover function can pull
        grep -oE "docid=[A-Za-z0-9_-]+" "$Q4_OUT" | sort -u \
          | sed 's|^docid=|[yt-id]\thttps://www.youtube.com/watch?v=|' >> "$TRACES"
        local dl_n xb_n yt_n
        dl_n=$(grep -c "^\[downloads\]" "$TRACES" 2>/dev/null || echo 0)
        xb_n=$(grep -c "^\[xbel\]"      "$TRACES" 2>/dev/null || echo 0)
        yt_n=$(grep -c "^\[yt-id\]"     "$TRACES" 2>/dev/null || echo 0)
        echo -e "  [downloads]  $dl_n entries (file paths from History.downloads)"
        echo -e "  [xbel]       $xb_n entries (file paths from recently-used.xbel)"
        echo -e "  [yt-id]      $yt_n entries (reconstructable YT URLs from IndexedDB)"

        # =========================================================================
        # SUMMARY
        # =========================================================================
        echo -e "\n📊 \033[1;36mSummary\033[0m"
        printf "  %-32s %d hits\n" "downloads table (.${format})"   "$(grep -c . "$Q1_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "visits/urls (converter+search)" "$(grep -c . "$Q2_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "cookies (converter+YouTube)"    "$(grep -c . "$Q3_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "IndexedDB (docid/list/refer.)"  "$(grep -c . "$Q4_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "Local/Session Storage strings"  "$(grep -c . "$Q5_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d hits\n" "recently-used.xbel (.${format})" "$(grep -c . "$Q6_OUT" 2>/dev/null || echo 0)"
        printf "  %-32s %d entries\n" "Consolidated traces"            "$(wc -l < "$TRACES")"

        # ---- export full payloads so a follow-up command can use them
        local OUT_DIR="${TMPDIR:-/tmp}/chromium-traces-$(date +%s)"
        mkdir -p "$OUT_DIR"
        cp "$Q1_OUT" "$OUT_DIR/01-downloads.txt"
        cp "$Q2_OUT" "$OUT_DIR/02-visits.txt"
        cp "$Q3_OUT" "$OUT_DIR/03-cookies.txt"
        cp "$Q4_OUT" "$OUT_DIR/04-indexeddb.txt"
        cp "$Q5_OUT" "$OUT_DIR/05-storage.txt"
        cp "$Q6_OUT" "$OUT_DIR/06-xbel.txt"
        cp "$TRACES" "$OUT_DIR/traces.tsv"
        echo -e "📁 Full dumps: \033[1m$OUT_DIR\033[0m"

        # =========================================================================
        # OPTIONAL: filter against filesystem with `find`
        # =========================================================================
        if [ "$filter_existing" -eq 0 ] && [ -t 0 ]; then
          local yn
          read -rp $'❓ Cross-check against filesystem (find for already-existing files)? [y/N]: ' yn
          [[ "$yn" =~ ^[Yy]$ ]] && filter_existing=1
        fi
        local MISSING="$OUT_DIR/missing.tsv"
        : > "$MISSING"
        if [ "$filter_existing" -eq 1 ]; then
          echo -e "\n🔬 \033[1mPHASE 6\033[0m — Filesystem cross-check via \`find\`"
          echo -e "  Search roots: ${search_roots[*]}"
          echo -e "  For each trace, matching basename against the filesystem."
          local n=0 total_traces; total_traces=$(wc -l < "$TRACES")
          while IFS=$'\t' read -r src target; do
            [ -z "$target" ] && continue
            n=$((n+1))
            local basename_only
            basename_only=$(basename "$target")
            local found=""
            for root in "${search_roots[@]}"; do
              [ -d "$root" ] || continue
              found=$(find "$root" -type f -name "$basename_only" -print -quit 2>/dev/null)
              [ -n "$found" ] && break
            done
            if [ -n "$found" ]; then
              echo -e "  [$n/$total_traces] \033[32m✓\033[0m $basename_only  →  $found"
            else
              echo -e "  [$n/$total_traces] \033[31m✗\033[0m $basename_only  (missing)"
              printf "%s\t%s\n" "$src" "$target" >> "$MISSING"
            fi
          done < "$TRACES"
          echo -e "❎ Missing: \033[1m$(wc -l < "$MISSING")\033[0m / $(wc -l < "$TRACES")"
          echo -e "📋 Missing list:"
          sed 's/^/  /' "$MISSING"
        fi

        # =========================================================================
        # OPTIONAL: hand off YouTube-shaped missing traces to the recover function
        # =========================================================================
        local -a yt_urls=()
        while IFS=$'\t' read -r src target; do
          [ "$src" = "[yt-id]" ] && yt_urls+=("$target")
        done < "${MISSING:-$TRACES}"
        if [ "$redownload" -eq 0 ] && [ "${#yt_urls[@]}" -gt 0 ] && [ -t 0 ]; then
          local yn
          read -rp $'❓ '"${#yt_urls[@]}"$' YouTube-shaped traces found. Redownload them? [y/N]: ' yn
          [[ "$yn" =~ ^[Yy]$ ]] && redownload=1
        fi
        if [ "$redownload" -eq 1 ] && [ "${#yt_urls[@]}" -gt 0 ]; then
          echo -e "\n🔬 \033[1mPHASE 7\033[0m — Destination prompt (3 retries max)"
          local dest="" tries=0
          while [ "$tries" -lt 3 ]; do
            read -rp "  📍 Destination directory: " dest
            echo -e "  Validating: '$dest'"
            if [ -d "$dest" ] && [ -w "$dest" ]; then
              echo -e "  ✅ Exists + writable"; break
            fi
            if [ -z "$dest" ]; then echo -e "  ❌ Empty path."; tries=$((tries+1)); continue; fi
            read -rp "  Path does not exist or is not writable. Create '$dest'? [y/N]: " yn
            if [[ "$yn" =~ ^[Yy]$ ]] && mkdir -p "$dest" 2>/dev/null; then
              echo -e "  ✅ Created"; break
            fi
            echo -e "  ⚠️  Try again ($((tries+1))/3)"
            tries=$((tries+1))
          done
          if [ ! -d "$dest" ] || [ ! -w "$dest" ]; then
            echo -e "❌ Failed to obtain a valid destination after 3 attempts."
            return 2
          fi
          echo -e "\n🔬 \033[1mPHASE 8\033[0m — Handing off to recover_chromium_yt_downloads_by_traces"
          echo -e "  → ${#yt_urls[@]} URL(s)  →  $dest"
          if declare -F recover_chromium_yt_downloads_by_traces >/dev/null; then
            recover_chromium_yt_downloads_by_traces "$dest" "${yt_urls[@]}"
          else
            echo -e "❌ recover_chromium_yt_downloads_by_traces is not defined."
            return 3
          fi
        fi
        echo -e "\n🏁 \033[1;32msearch_chromium_download_traces complete\033[0m"
        return 0
      }
      alias search-chromium-download-traces='search_chromium_download_traces'

      ## @description Re-download a list of YouTube URLs (or video IDs) into a target
      ## @description directory. Companion to search_chromium_download_traces — the
      ## @description body holds the actual yt-dlp invocation, browser cookies, node
      ## @description JS runtime, and the post-process / verify step.
      ## @param $1 {string} dest_dir  - Destination directory (required, must exist + writable)
      ## @param $@ {url...}           - One or more YouTube URLs or 11-char IDs
      ## @flag --browser <name>       Browser to extract cookies from (default: brave)
      ## @flag --format <ext>         Audio container (default: mp3)
      ## @flag --quality <0-9>        --audio-quality (default: 0 = best)
      ## @flag --no-thumb             Skip embed-thumbnail step
      recover_chromium_yt_downloads_by_traces() {
        local dest="" browser="brave" format="mp3" quality="0" thumb="--embed-thumbnail"
        local -a urls=()
        while [[ $# -gt 0 ]]; do
          case "$1" in
            --browser)   browser="$2"; shift 2 ;;
            --format)    format="$2"; shift 2 ;;
            --quality)   quality="$2"; shift 2 ;;
            --no-thumb)  thumb=""; shift ;;
            -h|--help)
              echo -e "📖 \033[1mrecover_chromium_yt_downloads_by_traces\033[0m <dest_dir> <url|id> [<url|id>...]"
              return 0 ;;
            *)
              if [ -z "$dest" ]; then dest="$1"
              else urls+=("$1"); fi
              shift ;;
          esac
        done
        if [ -z "$dest" ] || [ "${#urls[@]}" -eq 0 ]; then
          echo -e "❌ Usage: recover_chromium_yt_downloads_by_traces <dest_dir> <url|id>..."
          return 1
        fi
        echo -e "🔬 \033[1mPHASE A\033[0m — Inputs validation"
        echo -e "  Destination: $dest"
        echo -e "  URLs queued: ${#urls[@]}"
        echo -e "  Browser cookies: $browser    Format: $format    Quality: $quality    Thumbs: ${thumb:-off}"
        [ ! -d "$dest" ] && { echo -e "❌ Destination not a dir: $dest"; return 1; }
        [ ! -w "$dest" ] && { echo -e "❌ Destination not writable: $dest"; return 1; }

        echo -e "🔬 \033[1mPHASE B\033[0m — Dependency check"
        command -v python3 >/dev/null && echo -e "  ✓ python3: $(command -v python3)" || { echo -e "❌ python3 required"; return 1; }
        python3 -c "import yt_dlp; import yt_dlp_ejs" 2>/dev/null \
          && echo -e "  ✓ yt_dlp + yt_dlp_ejs Python modules present" \
          || { echo -e "❌ Run: pip install --user --break-system-packages -U yt-dlp yt-dlp-ejs"; return 1; }
        command -v node >/dev/null && echo -e "  ✓ node: $(node --version 2>/dev/null)" \
          || echo -e "  ⚠️  node not found — YT JS challenges may fail."
        command -v ffmpeg >/dev/null && echo -e "  ✓ ffmpeg: $(ffmpeg -version 2>/dev/null | head -1)" \
          || { echo -e "❌ ffmpeg required for audio conversion"; return 1; }

        local LOG="/tmp/recover-chromium-yt-$(date +%Y%m%d-%H%M%S).log"
        echo -e "📜 Log file: $LOG"
        local -i ok=0 skipped=0 failed=0 total="${#urls[@]}" i=0
        echo -e "\n🎵 \033[1;36mPHASE C — Downloading $total URL(s) → $dest\033[0m"
        for u in "${urls[@]}"; do
          i=$((i+1))
          if [[ "$u" =~ ^[A-Za-z0-9_-]{11}$ ]]; then u="https://www.youtube.com/watch?v=$u"; fi
          echo -e "\n────────── [$i/$total] $u ──────────" | tee -a "$LOG"
          echo -e "  ⓘ Resolving title via yt-dlp --skip-download"
          local title
          title=$(python3 -m yt_dlp --no-js-runtimes --js-runtimes node \
                    --cookies-from-browser "$browser" --no-playlist --skip-download \
                    --print "%(title)s" "$u" 2>&1 | tee -a "$LOG" | tail -1)
          if [ -z "$title" ] || [[ "$title" == *"ERROR"* ]]; then
            echo -e "  ⚠️  Title not resolved — skipping"
            failed=$((failed+1)); continue
          fi
          local safe="${title//\//-}"; safe="${safe//$'\n'/ }"
          echo -e "  📝 Title:    $title"
          echo -e "  💾 Filename: $safe.$format"
          local out="$dest/$safe.$format"
          if [ -e "$out" ]; then
            echo -e "  ✋ Already exists — skip"
            skipped=$((skipped+1)); continue
          fi
          echo -e "  ⬇️  Invoking yt-dlp (bestaudio → $format @ q$quality)"
          if python3 -m yt_dlp --no-js-runtimes --js-runtimes node \
              --cookies-from-browser "$browser" \
              --no-playlist --retries 10 --fragment-retries 20 \
              --sleep-interval 2 --max-sleep-interval 5 \
              --extract-audio --audio-format "$format" --audio-quality "$quality" \
              $thumb --add-metadata --no-mtime \
              -f bestaudio \
              -o "$dest/$safe.%(ext)s" \
              "$u" 2>&1 | tee -a "$LOG" | grep -E "(\[download\] |\[ExtractAudio\]|\[EmbedThumbnail\]|ERROR|WARNING)" | sed 's/^/    /'; then
            if [ -f "$out" ]; then
              local dur
              dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$out" 2>/dev/null)
              echo -e "  ✅ Saved [$dur s]"
              ok=$((ok+1))
            else
              echo -e "  ❌ Expected output not found at $out"
              failed=$((failed+1))
            fi
          else
            echo -e "  ❌ yt-dlp exited non-zero"
            failed=$((failed+1))
          fi
        done
        echo -e "\n🏁 \033[1;32mPHASE D — Summary\033[0m"
        echo -e "  ✅ ok:      $ok"
        echo -e "  ✋ skipped: $skipped"
        echo -e "  ❌ failed:  $failed"
        echo -e "  📜 Log:     $LOG"
        [ "$failed" -gt 0 ] && return 2 || return 0
      }
      alias recover-chromium-yt-downloads-by-traces='recover_chromium_yt_downloads_by_traces'

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

