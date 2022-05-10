#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

convert_to_mp3() {
    local activation_bytes="$1"
    local audible_drm_audiobook="$2"
    ffmpeg -activation_bytes "$activation_bytes" -i "$audible_drm_audiobook" -threads 0 -map_metadata 0 -map_chapters 0 -id3v2_version 3 "${audible_drm_audiobook%.*}.mp3"
}

usage() {
    echo "Usage: $0 [--help] --activation-bytes ACTIVATION_BYTES [FILE ...]"
    echo
    echo "Convert Audible audiobooks to MP3s suitable for playing in players other than Audible's"
    echo
    echo "  -h, --help                                  Show this help and exit"
    echo "  -a, --activation-bytes ACTIVATION_BYTES     Your Audible user account's activation bytes"
    echo "                                              See: https://audible-converter.ml/"
}

# Run the conversion in parallel
convert_all_to_mp3() {
    local activation_bytes="$1"
    local -n audible_drm_audiobooks="$2"
    local max_jobs=8

    for audiobook in "${audible_drm_audiobooks[@]}"; do
        if test "$(jobs | wc -l)" -ge $max_jobs; then
            wait -n
        fi

        {
            convert_to_mp3 "$activation_bytes" "$audiobook"
        } &
    done
    wait
}

main() {
    local activation_bytes=""
    local audiobooks=()

    while test $# -gt 0; do
        case "$1" in
        --help | -h)
            usage
            exit
            ;;
        --activation-bytes | -a)
            activation_bytes="$2"
            shift
            ;;
        *)
            audiobooks+=("$1")
            ;;
        esac
        shift
    done

    convert_all_to_mp3 "$activation_bytes" audiobooks
}

main "$@"
