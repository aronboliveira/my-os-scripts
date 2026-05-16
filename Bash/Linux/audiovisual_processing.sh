  #region Audiovisual_Processing
    gif_to_mp4() {
        local input="$1"
        local output="${2:-${input%.gif}.mp4}"

        # Guard clauses
        if ! command -v ffmpeg &>/dev/null; then
            echo "ERROR: ffmpeg not found" >&2
            return 1
        fi
        if [[ -z "$input" ]]; then
            echo "Usage: gif_to_mp4 <input.gif> [output.mp4]" >&2
            return 1
        fi
        if [[ ! -f "$input" ]]; then
            echo "ERROR: Input file '$input' not found" >&2
            return 1
        fi
        if [[ -f "$output" ]]; then
            echo "WARNING: Output '$output' already exists, overwriting..." >&2
        fi

        echo "Converting GIF '$input' -> MP4 '$output' ..."
        ffmpeg -i "$input" -c:v libx264 -pix_fmt yuv420p "$output" && \
            echo "✅ Success: $output" || {
                echo "❌ Conversion failed" >&2
                return 1
            }
    }
    ## Convert webm to mp4 (re-encode video stream, copy audio if present)
    # @param $1 input file
    # @param $2 output file (optional, defaults to input name with .mp4 extension)
    webm_to_mp4() {
        local input="$1"
        local output="${2:-${input%.webm}.mp4}"

        if ! command -v ffmpeg &>/dev/null; then
            echo "ERROR: ffmpeg not found" >&2
            return 1
        fi
        if [[ -z "$input" ]]; then
            echo "Usage: webm_to_mp4 <input.webm> [output.mp4]" >&2
            return 1
        fi
        if [[ ! -f "$input" ]]; then
            echo "ERROR: Input file '$input' not found" >&2
            return 1
        fi
        if [[ -f "$output" ]]; then
            echo "WARNING: Output '$output' already exists, overwriting..." >&2
        fi

        echo "Converting WebM '$input' -> MP4 '$output' ..."
        ffmpeg -v warning -i "$input" \
            -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
            -c:v libx264 -crf 18 -c:a aac -b:a 192k "$output" && \
            echo "✅ Success: $output" || {
                echo "❌ Conversion failed" >&2
                return 1
            }
    }
    ## Split a video into multiple GIF chunks of specified duration, with optional scaling and fps settings
    # @param $1 input video file (e.g. input.mp4)
    # @param $2 chunk duration in seconds (optional, default 60)
    # @param $3 target fps for output GIFs (optional, default 15)
    # @param $4 target width for output GIFs (optional, default 480, maintains aspect ratio)
    # @param $5 target height for output GIFs (optional, maintains aspect ratio)
    # @param $6 output filename prefix (optional, default "video", results in video_00.gif, video_01.gif, etc.)
    video_to_gif_chunks() {
        local input="$1"
        local chunk_duration="${2:-60}"      # seconds per chunk
        local fps="${3:-15}"
        local width="${4:-480}"
        local prefix="${5:-video}"

        if ! command -v ffmpeg &>/dev/null || ! command -v ffprobe &>/dev/null; then
            echo "ERROR: ffmpeg and ffprobe are required" >&2
            return 1
        fi
        if [[ -z "$input" ]]; then
            echo "Usage: video_to_gif_chunks <input.mp4> [chunk_duration=60] [fps=15] [width=480] [prefix=video]" >&2
            return 1
        fi
        if [[ ! -f "$input" ]]; then
            echo "ERROR: Input file '$input' not found" >&2
            return 1
        fi
        if [[ ! "$chunk_duration" =~ ^[0-9]+$ ]] || [[ "$chunk_duration" -le 0 ]]; then
            echo "ERROR: chunk_duration must be a positive integer (seconds)" >&2
            return 1
        fi

        # Get total duration (integer seconds)
        local duration
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input" | cut -d. -f1)
        if [[ -z "$duration" ]]; then
            echo "ERROR: Could not read duration from '$input'" >&2
            return 1
        fi

        echo "Splitting '$input' (duration ${duration}s) into ${chunk_duration}s GIF chunks..."
        local c=0
        local success_count=0
        for ((i=0; i<=duration; i+=chunk_duration)); do
            local index=$(printf "%02d" "$c")
            local output="${prefix}_${index}.gif"
            echo "Processing chunk $c: $output"
            ffmpeg -v error -ss "$i" -t "$chunk_duration" -i "$input" \
                -vf "fps=$fps,scale=$width:-1:flags=lanczos" -y "$output" && \
                ((success_count++))
            ((c++))
        done

        echo "✅ Done! $success_count GIF chunk(s) created."
        if [[ $success_count -eq 0 ]]; then
            echo "WARNING: No chunks were generated" >&2
            return 1
        fi
    }
    ## Concatenate multiple .m4s video segments into a single MP4 file using ffmpeg's concat demuxer
    # @param $1 output file (e.g. output.mp4)
    # @PARAM $2... input .m4s files (e.g. part0.m4s part1.m4s part2.m4s)
    concat_m4s() {
        if [ $# -lt 2 ]; then
            echo "Usage: ffmpeg_concat_m4s <output_file> <input_part1> [input_part2] ..."
            echo "Example: ffmpeg_concat_m4s output.mp4 part0.m4s part1.m4s part2.m4s"
            return 1
        fi
        local output_file="$1"
        shift
        local concat_list=$(mktemp)
        for input_file in "$@"; do
            if [ ! -f "$input_file" ]; then
                echo "Error: File not found - $input_file"
                rm -f "$concat_list"
                return 1
            fi
            echo "file '$input_file'" >> "$concat_list"
        done
        ffmpeg -f concat -safe 0 -i "$concat_list" -c copy "$output_file"
        if [ $? -eq 0 ]; then
            echo "Successfully created: $output_file"
        else
            echo "Error: ffmpeg concatenation failed"
        fi
        rm -f "$concat_list"
    }
    ## Convert mp3 to oga (Ogg Vorbis)
    # @param $1... input .mp3 files (e.g. track1.mp3 track2.mp3)
    mp3_to_oga() {
      if ! command -v ffmpeg &>/dev/null; then
        echo "ERROR: ffmpeg not found" >&2
        return 1
      fi
      if [[ $# -eq 0 ]]; then
        echo "Usage: mp3_to_oga <file1.mp3> [file2.mp3 ...]" >&2
        return 1
      fi
        local quality="${FFMPEG_OGA_QUALITY:-3}"
        local codec="libvorbis"
        
        for input in "$@"; do
            local basename="${input%.mp3}"
            basename="${basename%.MP3}"
            local mp3_file="${basename}.mp3"
            local oga_file="${basename}.oga"
            
            [[ ! -f "$mp3_file" ]] && { echo "Missing: $mp3_file" >&2; continue; }
            [[ -z "$FORCE" && -f "$oga_file" ]] && { echo "Exists: $oga_file (FORCE=1 to overwrite)" >&2; continue; }
            
            ffmpeg -i "$mp3_file" \
                  -c:a "$codec" \
                  -q:a "$quality" \
                  -map_metadata 0 \
                  -loglevel error \
                  -nostdin \
                  ${FORCE:+-y} \
                  "$oga_file" </dev/null
        done
    }
    ## Convert mp4 to gif with palette optimization and optional scaling/fps/dithering
    # @param $1 input video file (e.g. input.mp4)
    # @param $2 output gif file (optional, defaults to input name with .gif extension)
    # @param $3 target width (optional, maintains aspect ratio)
    # @param $4 target height (optional, maintains aspect ratio)
    # @param $5 target fps (optional, defaults to input fps)
    # @param $6 dither method (optional, default "bayer:bayer_scale=5", set to "none" for no dithering)
    mp4_to_gif() {
        command -v ffmpeg  >/dev/null 2>&1 || { echo "ERROR: ffmpeg is required but not found." >&2; return 1; }
        command -v ffprobe >/dev/null 2>&1 || { echo "ERROR: ffprobe is required but not found." >&2; return 1; }

        local input="" output="" target_width="" target_height="" target_fps="" dither="bayer:bayer_scale=5"
        local usage="Usage: mp4-to-gif <input.mp4> [-o output.gif] [-w WIDTH] [-h HEIGHT] [-f FPS]"

        [[ $# -eq 0 ]] && { echo "$usage" >&2; return 1; }

        while [[ $# -gt 0 ]]; do
            case "$1" in
                -o) output="$2"; shift 2 ;;
                -w) target_width="$2"; shift 2 ;;
                -h) target_height="$2"; shift 2 ;;
                -f) target_fps="$2"; shift 2 ;;
                -*) echo "Unknown option: $1" >&2; echo "$usage" >&2; return 1 ;;
                *)  input="$1"; shift ;;
            esac
        done

        [[ -z "$input"   ]] && { echo "ERROR: no input file provided." >&2; return 1; }
        [[ ! -f "$input" ]] && { echo "ERROR: file '$input' not found." >&2; return 1; }

        local ext="${input##*.}"
        [[ "$ext" =~ ^(mp4|mov|mkv|avi|webm)$ ]] || { echo "ERROR: '$input' is not a recognised video file (.mp4/.mov/.mkv/.avi/.webm)." >&2; return 1; }

        local has_video
        has_video=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_type -of csv=p=0 "$input" 2>/dev/null)
        [[ "$has_video" == "video" ]] || { echo "ERROR: '$input' has no video stream." >&2; return 1; }

        local orig_width orig_height orig_fps
        IFS=',' read -r orig_width orig_height orig_fps < <(
            ffprobe -v error -select_streams v:0 \
                -show_entries stream=width,height,r_frame_rate \
                -of csv=p=0 "$input"
        )

        orig_fps=$(awk "BEGIN {printf \"%.2f\", ${orig_fps:-30/1}}")

        : "${output:=${input%.*}.gif}"
        : "${target_fps:=$orig_fps}"

        if [[ -f "$output" && "$output" != "${input%.*}.gif" ]]; then
            echo "WARNING: '$output' already exists. Overwrite? [y/N] "
            read -r reply
            [[ "$reply" =~ ^[Yy]$ ]] || { echo "Aborted."; return 1; }
        fi

        local scale_filter
        if [[ -n "$target_height" ]]; then
            scale_filter="scale=-2:${target_height}:flags=lanczos"
        elif [[ -n "$target_width" ]]; then
            scale_filter="scale=${target_width}:-2:flags=lanczos"
        else
            scale_filter="scale=${orig_width}:${orig_height}:flags=lanczos"
        fi

        echo "→ ${input}  (${orig_width}x${orig_height} @ ${orig_fps} fps)  →  ${output}"
        echo "  scale: ${scale_filter}   fps: ${target_fps}   dither: ${dither}"

        ffmpeg -y -i "$input" \
            -filter_complex \
                "[0:v] fps=${target_fps},${scale_filter},split[a][b];\
                [a]palettegen=max_colors=256:stats_mode=diff[p];\
                [b][p]paletteuse=dither=${dither}" \
            -loop 0 "$output"

        local ret=$?
        if [[ $ret -eq 0 ]]; then
            local size
            size=$(du -h "$output" | cut -f1)
            echo "✔ Done: ${output} (${size})"
        fi
        return $ret
    }
    ## Convert webm to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, defaults to input name with .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }
    ## Convert webm to aac
    ## @param $1 input file
    ## @param $2 output file (optional)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }
    ## Convert webm to wav (lossless PCM)
    ## @param $1 input file
    ## @param $2 output file (optional)
    ## @param $3 ignored (kept for interface consistency)
    webm_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }
    ## Convert webm to aiff (lossless PCM)
    ## @param $1 input file
    ## @param $2 output file (optional)
    ## @param $3 ignored
    webm_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }
    ## Convert webm to flac (lossless)
    ## @param $1 input file
    ## @param $2 output file (optional)
    ## @param $3 compression level 0-8 (optional, default 5)
    webm_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }
    ## Convert webm to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a container for ALAC)
    ## @param $3 ignored (ALAC is lossless)
    webm_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert webm to ogg (Opus or Vorbis, default Opus)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert webm to oga (Ogg Vorbis, .oga extension)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert webm to wma (Windows Media Audio)
    ## @param $3 audio bitrate (optional, default 192k)
    webm_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert mp4 to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }
    ## Convert mp4 to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert mp4 to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    mp4_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert mp4 to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    mp4_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert mp4 to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    mp4_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert mp4 to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    mp4_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }
    ## Convert mp4 to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert mp4 to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert mp4 to wma (Windows Media Audio)
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    mp4_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert mpg to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }
    ## Convert mpg to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }
    ## Convert mpg to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    mpg_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert mpg to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    mpg_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert mpg to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    mpg_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert mpg to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    mpg_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert mpg to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert mpg to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert mpg to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    mpg_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert ogg (video) to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert ogg (video) to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert ogg (video) to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    ogg_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }
    ## Convert ogg (video) to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    ogg_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert ogg (video) to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    ogg_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert ogg (video) to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    ogg_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert ogg (video) to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert ogg (video) to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert avi to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert avi to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert avi to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    avi_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert avi to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    avi_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert avi to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    avi_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert avi to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    avi_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert avi to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert avi to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert avi to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    avi_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert mov to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert mov to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert mov to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    mov_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert mov to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    mov_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert mov to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    mov_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert mov to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    mov_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert mov to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert mov to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert mov to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    mov_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert flv to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    flv_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert flv to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    flv_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert flv to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    flv_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert flv to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    flv_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert flv to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    flv_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert flv to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    flv_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert flv to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    flv_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert flv to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    flv_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert webm to mpg (MPEG-2)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF quality 18-28 (optional, default 23)
    ## @param $4 scale (optional, e.g., "1280:-1" or "640x480")
    webm_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert webm to ogg (Theora video)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    webm_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert webm to avi (MPEG-4)
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    webm_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert webm to mov (QuickTime)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    webm_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert webm to flv (Flash Video)
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    webm_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mp4 to mpg
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mp4_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert mp4 to ogg (Theora)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    mp4_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert mp4 to avi
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mp4_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert mp4 to mov
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mp4_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mp4 to flv
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mp4_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mpg to webm (VP9)
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional, e.g., "1280:-1")
    mpg_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert mpg to mp4
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mpg_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mpg to ogg (Theora)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    mpg_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert mpg to avi
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mpg_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert mpg to mov
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mpg_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mpg to flv
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mpg_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert ogg (Theora) to webm
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional)
    ogg_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert ogg to mp4
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert ogg to mpg
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert ogg to avi
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert mp4 to webm (VP9)
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional, e.g., "1280:-1")
    mp4_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert ogg (Theora) to mov (QuickTime H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert ogg to flv (Flash Video H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    ogg_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert avi to webm
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional)
    avi_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert avi to mp4
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    avi_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert avi to mpg (MPEG-2)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    avi_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert avi to ogg (Theora)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    avi_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert avi to mov
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    avi_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert avi to flv
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    avi_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mov to webm
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional)
    mov_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert mov to mp4 (H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional, e.g., "1280:-1")
    mov_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mov to mpg (MPEG-2/MP2)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mov_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert mov to ogg (Theora/Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    mov_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert mov to avi (H.264/MP3)
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mov_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert mov to flv (Flash H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .flv)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    mov_to_flv() {
        local input="$1"
        local output="${2:-${input%.*}.flv}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert flv to webm (VP9/Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .webm)
    ## @param $3 video CRF 0-63 (optional, default 30)
    ## @param $4 scale (optional)
    flv_to_webm() {
        local input="$1"
        local output="${2:-${input%.*}.webm}"
        local crf="${3:-30}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libvpx-vp9 -crf "$crf" -b:v 0 -c:a libopus "$output"
    }

    ## Convert flv to mp4 (H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp4)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    flv_to_mp4() {
        local input="$1"
        local output="${2:-${input%.*}.mp4}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert flv to mpg (MPEG-2/MP2)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mpg)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    flv_to_mpg() {
        local input="$1"
        local output="${2:-${input%.*}.mpg}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v mpeg2video -crf "$crf" -c:a mp2 "$output"
    }

    ## Convert flv to ogg (Theora/Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogv)
    ## @param $3 video quality 0-10 (optional, default 7)
    ## @param $4 scale (optional)
    flv_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogv}"
        local quality="${3:-7}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libtheora -q:v "$quality" -c:a libvorbis "$output"
    }

    ## Convert flv to avi (H.264/MP3)
    ## @param $1 input file
    ## @param $2 output file (optional, default .avi)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional)
    flv_to_avi() {
        local input="$1"
        local output="${2:-${input%.*}.avi}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a mp3 "$output"
    }

    ## Convert flv to mov (QuickTime H.264/AAC)
    ## @param $1 input file
    ## @param $2 output file (optional, default .mov)
    ## @param $3 video CRF 18-28 (optional, default 23)
    ## @param $4 scale (optional, e.g., "1280:-1")
    flv_to_mov() {
        local input="$1"
        local output="${2:-${input%.*}.mov}"
        local crf="${3:-23}"
        local scale="${4:-}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        local vf=""
        [[ -n "$scale" ]] && vf="-vf scale=$scale"
        ffmpeg -i "$input" $vf -c:v libx264 -crf "$crf" -c:a aac "$output"
    }

    ## Convert mp3 to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    mp3_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert mp3 to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    mp3_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert mp3 to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    mp3_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert mp3 to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    mp3_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert mp3 to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    mp3_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert mp3 to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    mp3_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert mp3 to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    mp3_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert mp3 to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    mp3_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert aac to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    aac_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert aac to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    aac_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert aac to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    aac_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert aac to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    aac_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert aac to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    aac_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert aac to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    aac_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert aac to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    aac_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert aac to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    aac_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert wav to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert wav to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert wav to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    wav_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert wav to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    wav_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert wav to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    wav_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert wav to ogg (Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert wav to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert wav to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    wav_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert aiff to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert aiff to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert aiff to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    aiff_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert aiff to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    aiff_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert aiff to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    aiff_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert aiff to ogg (Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert aiff to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert aiff to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    aiff_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert flac to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert flac to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert flac to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    flac_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert flac to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    flac_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert flac to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    flac_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert flac to ogg (Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert flac to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert flac to wma (Windows Media Audio)
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    flac_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert alac (Apple Lossless) to mp3
    ## @param $1 input file (usually .m4a)
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert alac to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert alac to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    alac_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert alac to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    alac_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert alac to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    alac_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert alac to ogg (Opus)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert alac to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert alac to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    alac_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert ogg audio (Opus or Vorbis) to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert ogg audio (Opus/Vorbis) to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert ogg audio to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    ogg_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert ogg audio to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    ogg_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert ogg audio to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    ogg_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert ogg audio to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    ogg_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert ogg audio to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    ## Convert ogg audio to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    ogg_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert oga (Ogg Vorbis) to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    oga_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert oga to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    oga_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert oga to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    oga_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert oga (Ogg Vorbis) to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    oga_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert oga to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    oga_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert oga to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    oga_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert oga to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    oga_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert oga to wma
    ## @param $1 input file
    ## @param $2 output file (optional, default .wma)
    ## @param $3 audio bitrate (optional, default 192k)
    oga_to_wma() {
        local input="$1"
        local output="${2:-${input%.*}.wma}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec wmav2 -b:a "$bitrate" "$output"
    }

    ## Convert wma (Windows Media Audio) to mp3
    ## @param $1 input file
    ## @param $2 output file (optional, default .mp3)
    ## @param $3 audio bitrate (optional, default 192k)
    wma_to_mp3() {
        local input="$1"
        local output="${2:-${input%.*}.mp3}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libmp3lame -b:a "$bitrate" "$output"
    }

    ## Convert wma to aac
    ## @param $1 input file
    ## @param $2 output file (optional, default .aac)
    ## @param $3 audio bitrate (optional, default 192k)
    wma_to_aac() {
        local input="$1"
        local output="${2:-${input%.*}.aac}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec aac -b:a "$bitrate" "$output"
    }

    ## Convert wma to wav
    ## @param $1 input file
    ## @param $2 output file (optional, default .wav)
    ## @param $3 ignored
    wma_to_wav() {
        local input="$1"
        local output="${2:-${input%.*}.wav}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16le "$output"
    }

    ## Convert wma to aiff
    ## @param $1 input file
    ## @param $2 output file (optional, default .aiff)
    ## @param $3 ignored
    wma_to_aiff() {
        local input="$1"
        local output="${2:-${input%.*}.aiff}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec pcm_s16be "$output"
    }

    ## Convert wma to flac
    ## @param $1 input file
    ## @param $2 output file (optional, default .flac)
    ## @param $3 compression level 0-8 (optional, default 5)
    wma_to_flac() {
        local input="$1"
        local output="${2:-${input%.*}.flac}"
        local compression="${3:-5}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec flac -compression_level "$compression" "$output"
    }

    ## Convert wma to alac (Apple Lossless)
    ## @param $1 input file
    ## @param $2 output file (optional, default .m4a)
    ## @param $3 ignored
    wma_to_alac() {
        local input="$1"
        local output="${2:-${input%.*}.m4a}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec alac "$output"
    }

    ## Convert wma to ogg (Opus codec)
    ## @param $1 input file
    ## @param $2 output file (optional, default .ogg)
    ## @param $3 audio bitrate (optional, default 192k)
    wma_to_ogg() {
        local input="$1"
        local output="${2:-${input%.*}.ogg}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libopus -b:a "$bitrate" "$output"
    }

    ## Convert wma to oga (Ogg Vorbis)
    ## @param $1 input file
    ## @param $2 output file (optional, default .oga)
    ## @param $3 audio bitrate (optional, default 192k)
    wma_to_oga() {
        local input="$1"
        local output="${2:-${input%.*}.oga}"
        local bitrate="${3:-192k}"
        [[ ! -f "$input" ]] && echo "Error: File not found" && return 1
        ffmpeg -i "$input" -vn -acodec libvorbis -b:a "$bitrate" "$output"
    }

    alias gif-to-mp4='gif_to_mp4'
    alias webm-to-mp4='webm_to_mp4'
    alias video-to-gif-chunks='video_to_gif_chunks'
    alias mp3-to-oga='mp3_to_oga'
    alias concat-m4s='concat_m4s'
    alias mp4-to-gif='mp4_to_gif'
    alias ffmpeg-gif-to-mp4='gif_to_mp4'
    alias ffmpeg-webm-to-mp4='webm_to_mp4'
    alias ffmpeg-video-to-gif-chunks='video_to_gif_chunks'
    alias ffmpeg-mp3-to-oga='mp3_to_oga'
    alias ffmpeg-concat-m4s='concat_m4s'
    alias ffmpeg-mp4-to-gif='mp4_to_gif'
    alias ffmpeg-webm-to-mp3='webm_to_mp3'
    alias webm-to-mp3='webm_to_mp3'
    alias ffmpeg-webm-to-aac='webm_to_aac'
    alias webm-to-aac='webm_to_aac'
    alias ffmpeg-webm-to-wav='webm_to_wav'
    alias webm-to-wav='webm_to_wav'
    alias ffmpeg-webm-to-aiff='webm_to_aiff'
    alias webm-to-aiff='webm_to_aiff'
    alias ffmpeg-webm-to-flac='webm_to_flac'
    alias webm-to-flac='webm_to_flac'
    alias ffmpeg-webm-to-alac='webm_to_alac'
    alias webm-to-alac='webm_to_alac'
    alias ffmpeg-webm-to-ogg='webm_to_ogg'
    alias webm-to-ogg='webm_to_ogg'
    alias ffmpeg-webm-to-oga='webm_to_oga'
    alias webm-to-oga='webm_to_oga'
    alias ffmpeg-webm-to-wma='webm_to_wma'
    alias webm-to-wma='webm_to_wma'
    alias ffmpeg-mp4-to-mp3='mp4_to_mp3'
    alias mp4-to-mp3='mp4_to_mp3'
    alias ffmpeg-mp4-to-aac='mp4_to_aac'
    alias mp4-to-aac='mp4_to_aac'
    alias ffmpeg-mp4-to-wav='mp4_to_wav'
    alias mp4-to-wav='mp4_to_wav'
    alias ffmpeg-mp4-to-aiff='mp4_to_aiff'
    alias mp4-to-aiff='mp4_to_aiff'
    alias ffmpeg-mp4-to-flac='mp4_to_flac'
    alias mp4-to-flac='mp4_to_flac'
    alias ffmpeg-mp4-to-alac='mp4_to_alac'
    alias mp4-to-alac='mp4_to_alac'
    alias ffmpeg-mp4-to-ogg='mp4_to_ogg'
    alias mp4-to-ogg='mp4_to_ogg'
    alias ffmpeg-mp4-to-oga='mp4_to_oga'
    alias mp4-to-oga='mp4_to_oga'
    alias ffmpeg-mp4-to-wma='mp4_to_wma'
    alias mp4-to-wma='mp4_to_wma'
    alias ffmpeg-mpg-to-mp3='mpg_to_mp3'
    alias mpg-to-mp3='mpg_to_mp3'
    alias ffmpeg-mpg-to-aac='mpg_to_aac'
    alias mpg-to-aac='mpg_to_aac'
    alias ffmpeg-mpg-to-wav='mpg_to_wav'
    alias mpg-to-wav='mpg_to_wav'
    alias ffmpeg-mpg-to-aiff='mpg_to_aiff'
    alias mpg-to-aiff='mpg_to_aiff'
    alias ffmpeg-mpg-to-flac='mpg_to_flac'
    alias mpg-to-flac='mpg_to_flac'
    alias ffmpeg-mpg-to-alac='mpg_to_alac'
    alias mpg-to-alac='mpg_to_alac'
    alias ffmpeg-mpg-to-ogg='mpg_to_ogg'
    alias mpg-to-ogg='mpg_to_ogg'
    alias ffmpeg-mpg-to-oga='mpg_to_oga'
    alias mpg-to-oga='mpg_to_oga'
    alias ffmpeg-mpg-to-wma='mpg_to_wma'
    alias mpg-to-wma='mpg_to_wma'
    alias ffmpeg-ogg-to-mp3='ogg_to_mp3'
    alias ogg-to-mp3='ogg_to_mp3'
    alias ffmpeg-ogg-to-aac='ogg_to_aac'
    alias ogg-to-aac='ogg_to_aac'
    alias ffmpeg-ogg-to-wav='ogg_to_wav'
    alias ogg-to-wav='ogg_to_wav'
    alias ffmpeg-ogg-to-aiff='ogg_to_aiff'
    alias ogg-to-aiff='ogg_to_aiff'
    alias ffmpeg-ogg-to-flac='ogg_to_flac'
    alias ogg-to-flac='ogg_to_flac'
    alias ffmpeg-ogg-to-alac='ogg_to_alac'
    alias ogg-to-alac='ogg_to_alac'
    alias ffmpeg-ogg-to-ogg='ogg_to_ogg'
    alias ogg-to-ogg='ogg_to_ogg'
    alias ffmpeg-ogg-to-oga='ogg_to_oga'
    alias ogg-to-oga='ogg_to_oga'
    alias ffmpeg-ogg-to-wma='ogg_to_wma'
    alias ogg-to-wma='ogg_to_wma'
    alias ffmpeg-avi-to-mp3='avi_to_mp3'
    alias avi-to-mp3='avi_to_mp3'
    alias ffmpeg-avi-to-aac='avi_to_aac'
    alias avi-to-aac='avi_to_aac'
    alias ffmpeg-avi-to-wav='avi_to_wav'
    alias avi-to-wav='avi_to_wav'
    alias ffmpeg-avi-to-aiff='avi_to_aiff'
    alias avi-to-aiff='avi_to_aiff'
    alias ffmpeg-avi-to-flac='avi_to_flac'
    alias avi-to-flac='avi_to_flac'
    alias ffmpeg-avi-to-alac='avi_to_alac'
    alias avi-to-alac='avi_to_alac'
    alias ffmpeg-avi-to-ogg='avi_to_ogg'
    alias avi-to-ogg='avi_to_ogg'
    alias ffmpeg-avi-to-oga='avi_to_oga'
    alias avi-to-oga='avi_to_oga'
    alias ffmpeg-avi-to-wma='avi_to_wma'
    alias avi-to-wma='avi_to_wma'
    alias ffmpeg-mov-to-mp3='mov_to_mp3'
    alias mov-to-mp3='mov_to_mp3'
    alias ffmpeg-mov-to-aac='mov_to_aac'
    alias mov-to-aac='mov_to_aac'
    alias ffmpeg-mov-to-wav='mov_to_wav'
    alias mov-to-wav='mov_to_wav'
    alias ffmpeg-mov-to-aiff='mov_to_aiff'
    alias mov-to-aiff='mov_to_aiff'
    alias ffmpeg-mov-to-flac='mov_to_flac'
    alias mov-to-flac='mov_to_flac'
    alias ffmpeg-mov-to-alac='mov_to_alac'
    alias mov-to-alac='mov_to_alac'
    alias ffmpeg-mov-to-ogg='mov_to_ogg'
    alias mov-to-ogg='mov_to_ogg'
    alias ffmpeg-mov-to-oga='mov_to_oga'
    alias mov-to-oga='mov_to_oga'
    alias ffmpeg-mov-to-wma='mov_to_wma'
    alias mov-to-wma='mov_to_wma'
    alias ffmpeg-flv-to-mp3='flv_to_mp3'
    alias flv-to-mp3='flv_to_mp3'
    alias ffmpeg-flv-to-aac='flv_to_aac'
    alias flv-to-aac='flv_to_aac'
    alias ffmpeg-flv-to-wav='flv_to_wav'
    alias flv-to-wav='flv_to_wav'
    alias ffmpeg-flv-to-aiff='flv_to_aiff'
    alias flv-to-aiff='flv_to_aiff'
    alias ffmpeg-flv-to-flac='flv_to_flac'
    alias flv-to-flac='flv_to_flac'
    alias ffmpeg-flv-to-alac='flv_to_alac'
    alias flv-to-alac='flv_to_alac'
    alias ffmpeg-flv-to-ogg='flv_to_ogg'
    alias flv-to-ogg='flv_to_ogg'
    alias ffmpeg-flv-to-oga='flv_to_oga'
    alias flv-to-oga='flv_to_oga'
    alias ffmpeg-flv-to-wma='flv_to_wma'
    alias flv-to-wma='flv_to_wma'
    alias ffmpeg-webm-to-mpg='webm_to_mpg'
    alias webm-to-mpg='webm_to_mpg'
    alias ffmpeg-webm-to-ogg='webm_to_ogg'
    alias webm-to-ogg='webm_to_ogg'
    alias ffmpeg-webm-to-avi='webm_to_avi'
    alias webm-to-avi='webm_to_avi'
    alias ffmpeg-webm-to-mov='webm_to_mov'
    alias webm-to-mov='webm_to_mov'
    alias ffmpeg-webm-to-flv='webm_to_flv'
    alias webm-to-flv='webm_to_flv'
    alias ffmpeg-mp4-to-webm='mp4_to_webm'
    alias mp4-to-webm='mp4_to_webm'
    alias ffmpeg-mp4-to-mpg='mp4_to_mpg'
    alias mp4-to-mpg='mp4_to_mpg'
    alias ffmpeg-mp4-to-ogg='mp4_to_ogg'
    alias mp4-to-ogg='mp4_to_ogg'
    alias ffmpeg-mp4-to-avi='mp4_to_avi'
    alias mp4-to-avi='mp4_to_avi'
    alias ffmpeg-mp4-to-mov='mp4_to_mov'
    alias mp4-to-mov='mp4_to_mov'
    alias ffmpeg-mp4-to-flv='mp4_to_flv'
    alias mp4-to-flv='mp4_to_flv'
    alias ffmpeg-mpg-to-webm='mpg_to_webm'
    alias mpg-to-webm='mpg_to_webm'
    alias ffmpeg-mpg-to-mp4='mpg_to_mp4'
    alias mpg-to-mp4='mpg_to_mp4'
    alias ffmpeg-mpg-to-ogg='mpg_to_ogg'
    alias mpg-to-ogg='mpg_to_ogg'
    alias ffmpeg-mpg-to-avi='mpg_to_avi'
    alias mpg-to-avi='mpg_to_avi'
    alias ffmpeg-mpg-to-mov='mpg_to_mov'
    alias mpg-to-mov='mpg_to_mov'
    alias ffmpeg-mpg-to-flv='mpg_to_flv'
    alias mpg-to-flv='mpg_to_flv'
    alias ffmpeg-ogg-to-webm='ogg_to_webm'
    alias ogg-to-webm='ogg_to_webm'
    alias ffmpeg-ogg-to-mp4='ogg_to_mp4'
    alias ogg-to-mp4='ogg_to_mp4'
    alias ffmpeg-ogg-to-mpg='ogg_to_mpg'
    alias ogg-to-mpg='ogg_to_mpg'
    alias ffmpeg-ogg-to-avi='ogg_to_avi'
    alias ogg-to-avi='ogg_to_avi'
    alias ffmpeg-ogg-to-mov='ogg_to_mov'
    alias ogg-to-mov='ogg_to_mov'
    alias ffmpeg-ogg-to-flv='ogg_to_flv'
    alias ogg-to-flv='ogg_to_flv'
    alias ffmpeg-avi-to-webm='avi_to_webm'
    alias avi-to-webm='avi_to_webm'
    alias ffmpeg-avi-to-mp4='avi_to_mp4'
    alias avi-to-mp4='avi_to_mp4'
    alias ffmpeg-avi-to-mpg='avi_to_mpg'
    alias avi-to-mpg='avi_to_mpg'
    alias ffmpeg-avi-to-ogg='avi_to_ogg'
    alias avi-to-ogg='avi_to_ogg'
    alias ffmpeg-avi-to-mov='avi_to_mov'
    alias avi-to-mov='avi_to_mov'
    alias ffmpeg-avi-to-flv='avi_to_flv'
    alias avi-to-flv='avi_to_flv'
    alias ffmpeg-mov-to-webm='mov_to_webm'
    alias mov-to-webm='mov_to_webm'
    alias ffmpeg-mov-to-mp4='mov_to_mp4'
    alias mov-to-mp4='mov_to_mp4'
    alias ffmpeg-mov-to-mpg='mov_to_mpg'
    alias mov-to-mpg='mov_to_mpg'
    alias ffmpeg-mov-to-ogg='mov_to_ogg'
    alias mov-to-ogg='mov_to_ogg'
    alias ffmpeg-mov-to-avi='mov_to_avi'
    alias mov-to-avi='mov_to_avi'
    alias ffmpeg-mov-to-flv='mov_to_flv'
    alias mov-to-flv='mov_to_flv'
    alias ffmpeg-flv-to-webm='flv_to_webm'
    alias flv-to-webm='flv_to_webm'
    alias ffmpeg-flv-to-mp4='flv_to_mp4'
    alias flv-to-mp4='flv_to_mp4'
    alias ffmpeg-flv-to-mpg='flv_to_mpg'
    alias flv-to-mpg='flv_to_mpg'
    alias ffmpeg-flv-to-ogg='flv_to_ogg'
    alias flv-to-ogg='flv_to_ogg'
    alias ffmpeg-flv-to-avi='flv_to_avi'
    alias flv-to-avi='flv_to_avi'
    alias ffmpeg-flv-to-mov='flv_to_mov'
    alias flv-to-mov='flv_to_mov'
    alias ffmpeg-mp3-to-aac='mp3_to_aac'
    alias mp3-to-aac='mp3_to_aac'
    alias ffmpeg-mp3-to-wav='mp3_to_wav'
    alias mp3-to-wav='mp3_to_wav'
    alias ffmpeg-mp3-to-aiff='mp3_to_aiff'
    alias mp3-to-aiff='mp3_to_aiff'
    alias ffmpeg-mp3-to-flac='mp3_to_flac'
    alias mp3-to-flac='mp3_to_flac'
    alias ffmpeg-mp3-to-alac='mp3_to_alac'
    alias mp3-to-alac='mp3_to_alac'
    alias ffmpeg-mp3-to-ogg='mp3_to_ogg'
    alias mp3-to-ogg='mp3_to_ogg'
    alias ffmpeg-mp3-to-oga='mp3_to_oga'
    alias mp3-to-oga='mp3_to_oga'
    alias ffmpeg-mp3-to-wma='mp3_to_wma'
    alias mp3-to-wma='mp3_to_wma'
    alias ffmpeg-aac-to-mp3='aac_to_mp3'
    alias aac-to-mp3='aac_to_mp3'
    alias ffmpeg-aac-to-wav='aac_to_wav'
    alias aac-to-wav='aac_to_wav'
    alias ffmpeg-aac-to-aiff='aac_to_aiff'
    alias aac-to-aiff='aac_to_aiff'
    alias ffmpeg-aac-to-flac='aac_to_flac'
    alias aac-to-flac='aac_to_flac'
    alias ffmpeg-aac-to-alac='aac_to_alac'
    alias aac-to-alac='aac_to_alac'
    alias ffmpeg-aac-to-ogg='aac_to_ogg'
    alias aac-to-ogg='aac_to_ogg'
    alias ffmpeg-aac-to-oga='aac_to_oga'
    alias aac-to-oga='aac_to_oga'
    alias ffmpeg-aac-to-wma='aac_to_wma'
    alias aac-to-wma='aac_to_wma'
    alias ffmpeg-wav-to-mp3='wav_to_mp3'
    alias wav-to-mp3='wav_to_mp3'
    alias ffmpeg-wav-to-aac='wav_to_aac'
    alias wav-to-aac='wav_to_aac'
    alias ffmpeg-wav-to-aiff='wav_to_aiff'
    alias wav-to-aiff='wav_to_aiff'
    alias ffmpeg-wav-to-flac='wav_to_flac'
    alias wav-to-flac='wav_to_flac'
    alias ffmpeg-wav-to-alac='wav_to_alac'
    alias wav-to-alac='wav_to_alac'
    alias ffmpeg-wav-to-ogg='wav_to_ogg'
    alias wav-to-ogg='wav_to_ogg'
    alias ffmpeg-wav-to-oga='wav_to_oga'
    alias wav-to-oga='wav_to_oga'
    alias ffmpeg-wav-to-wma='wav_to_wma'
    alias wav-to-wma='wav_to_wma'
    alias ffmpeg-aiff-to-mp3='aiff_to_mp3'
    alias aiff-to-mp3='aiff_to_mp3'
    alias ffmpeg-aiff-to-aac='aiff_to_aac'
    alias aiff-to-aac='aiff_to_aac'
    alias ffmpeg-aiff-to-wav='aiff_to_wav'
    alias aiff-to-wav='aiff_to_wav'
    alias ffmpeg-aiff-to-flac='aiff_to_flac'
    alias aiff-to-flac='aiff_to_flac'
    alias ffmpeg-aiff-to-alac='aiff_to_alac'
    alias aiff-to-alac='aiff_to_alac'
    alias ffmpeg-aiff-to-ogg='aiff_to_ogg'
    alias aiff-to-ogg='aiff_to_ogg'
    alias ffmpeg-aiff-to-oga='aiff_to_oga'
    alias aiff-to-oga='aiff_to_oga'
    alias ffmpeg-aiff-to-wma='aiff_to_wma'
    alias aiff-to-wma='aiff_to_wma'
    alias ffmpeg-flac-to-mp3='flac_to_mp3'
    alias flac-to-mp3='flac_to_mp3'
    alias ffmpeg-flac-to-aac='flac_to_aac'
    alias flac-to-aac='flac_to_aac'
    alias ffmpeg-flac-to-wav='flac_to_wav'
    alias flac-to-wav='flac_to_wav'
    alias ffmpeg-flac-to-aiff='flac_to_aiff'
    alias flac-to-aiff='flac_to_aiff'
    alias ffmpeg-flac-to-alac='flac_to_alac'
    alias flac-to-alac='flac_to_alac'
    alias ffmpeg-flac-to-ogg='flac_to_ogg'
    alias flac-to-ogg='flac_to_ogg'
    alias ffmpeg-flac-to-oga='flac_to_oga'
    alias flac-to-oga='flac_to_oga'
    alias ffmpeg-flac-to-wma='flac_to_wma'
    alias flac-to-wma='flac_to_wma'
    alias ffmpeg-alac-to-mp3='alac_to_mp3'
    alias alac-to-mp3='alac_to_mp3'
    alias ffmpeg-alac-to-aac='alac_to_aac'
    alias alac-to-aac='alac_to_aac'
    alias ffmpeg-alac-to-wav='alac_to_wav'
    alias alac-to-wav='alac_to_wav'
    alias ffmpeg-alac-to-aiff='alac_to_aiff'
    alias alac-to-aiff='alac_to_aiff'
    alias ffmpeg-alac-to-flac='alac_to_flac'
    alias alac-to-flac='alac_to_flac'
    alias ffmpeg-alac-to-ogg='alac_to_ogg'
    alias alac-to-ogg='alac_to_ogg'
    alias ffmpeg-alac-to-oga='alac_to_oga'
    alias alac-to-oga='alac_to_oga'
    alias ffmpeg-alac-to-wma='alac_to_wma'
    alias alac-to-wma='alac_to_wma'
    alias ffmpeg-ogg-to-mp3='ogg_to_mp3'
    alias ogg-to-mp3='ogg_to_mp3'
    alias ffmpeg-ogg-to-aac='ogg_to_aac'
    alias ogg-to-aac='ogg_to_aac'
    alias ffmpeg-ogg-to-wav='ogg_to_wav'
    alias ogg-to-wav='ogg_to_wav'
    alias ffmpeg-ogg-to-aiff='ogg_to_aiff'
    alias ogg-to-aiff='ogg_to_aiff'
    alias ffmpeg-ogg-to-flac='ogg_to_flac'
    alias ogg-to-flac='ogg_to_flac'
    alias ffmpeg-ogg-to-alac='ogg_to_alac'
    alias ogg-to-alac='ogg_to_alac'
    alias ffmpeg-ogg-to-oga='ogg_to_oga'
    alias ogg-to-oga='ogg_to_oga'
    alias ffmpeg-ogg-to-wma='ogg_to_wma'
    alias ogg-to-wma='ogg_to_wma'
    alias ffmpeg-oga-to-mp3='oga_to_mp3'
    alias oga-to-mp3='oga_to_mp3'
    alias ffmpeg-oga-to-aac='oga_to_aac'
    alias oga-to-aac='oga_to_aac'
    alias ffmpeg-oga-to-wav='oga_to_wav'
    alias oga-to-wav='oga_to_wav'
    alias ffmpeg-oga-to-aiff='oga_to_aiff'
    alias oga-to-aiff='oga_to_aiff'
    alias ffmpeg-oga-to-flac='oga_to_flac'
    alias oga-to-flac='oga_to_flac'
    alias ffmpeg-oga-to-alac='oga_to_alac'
    alias oga-to-alac='oga_to_alac'
    alias ffmpeg-oga-to-ogg='oga_to_ogg'
    alias oga-to-ogg='oga_to_ogg'
    alias ffmpeg-oga-to-wma='oga_to_wma'
    alias oga-to-wma='oga_to_wma'
    alias ffmpeg-wma-to-mp3='wma_to_mp3'
    alias wma-to-mp3='wma_to_mp3'
    alias ffmpeg-wma-to-aac='wma_to_aac'
    alias wma-to-aac='wma_to_aac'
    alias ffmpeg-wma-to-wav='wma_to_wav'
    alias wma-to-wav='wma_to_wav'
    alias ffmpeg-wma-to-aiff='wma_to_aiff'
    alias wma-to-aiff='wma_to_aiff'
    alias ffmpeg-wma-to-flac='wma_to_flac'
    alias wma-to-flac='wma_to_flac'
    alias ffmpeg-wma-to-alac='wma_to_alac'
    alias wma-to-alac='wma_to_alac'
    alias ffmpeg-wma-to-ogg='wma_to_ogg'
    alias wma-to-ogg='wma_to_ogg'
    alias ffmpeg-wma-to-oga='wma_to_oga'
    alias wma-to-oga='wma_to_oga'
  #endregion Audiovisual_Processing

