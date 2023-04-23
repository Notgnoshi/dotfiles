#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

convert_to_mp3() {
    local activation_bytes="$1"
    local aax="$2"

    if ! ffmpeg \
        -activation_bytes "$activation_bytes" \
        -i "$aax" \
        -threads 0 \
        -map_metadata 0 \
        -map_chapters 0 \
        -id3v2_version 3 \
        "${aax%.*}.mp3" \
        ; then
        echo "Failed to convert $aax" >&2
    fi
}

usage() {
    echo "Usage: $0 [--help] --activation-bytes ACTIVATION_BYTES [FILE ...]"
    echo
    echo "Convert Audible audiobooks to MP3s suitable for playing in players other than Audible's"
    echo
    echo "  -h, --help                                  Show this help and exit"
    echo "  -a, --activation-bytes ACTIVATION_BYTES     Your Audible user account's activation bytes"
    echo "                                              See: https://audible-converter.ml/"
    echo "  -j, --jobs JOBS                             Number of jobs to use"
}

# Run the conversion in parallel
convert_all_to_mp3() {
    local activation_bytes="$1"
    local -n aaxs="$2"
    local max_jobs="$3"

    for audiobook in "${aaxs[@]}"; do
        if test "$(jobs | wc -l)" -ge "$max_jobs"; then
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
    local jobs=8

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
        --jobs | -j)
            jobs="$2"
            shift
            ;;
        *)
            audiobooks+=("$1")
            ;;
        esac
        shift
    done

    convert_all_to_mp3 "$activation_bytes" audiobooks "$jobs"
}

main "$@"
