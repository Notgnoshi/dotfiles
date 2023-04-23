#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

usage() {
    cat <<EOF
Usage: $0 [--help] [--jobs]

Increase CPU load.

Optional arguments:
    --help, -h      Show this help and exit
    --jobs, -j      Number of cores to use. Defaults to the total number of processors.
EOF
}

trap killgroup SIGINT
killgroup() {
    echo "Done."
    exit 0
}

worker() {
    local _worker_id="$1"
    # gzip --best --to-stdout /dev/urandom >/dev/null
    # sha256sum /dev/zero
    sha256sum /dev/urandom
}

cpuload() {
    local num_jobs="$1"

    echo "Generating CPU load with $num_jobs jobs..."

    local id
    for id in $(seq 1 "$num_jobs"); do
        worker "$id" &
    done

    wait
}

main() {
    local num_jobs
    num_jobs="$(nproc)"

    while [[ $# -gt 0 ]]; do
        case "$1" in
        --help | -h)
            usage
            exit
            ;;
        --jobs | -j)
            num_jobs="$2"
            shift
            ;;
        esac
        shift
    done
    cpuload "$num_jobs"
}

main "$@"
