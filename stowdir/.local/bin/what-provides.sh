#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
RESET="\033[0m"

debug() {
    echo -e "${BLUE}DEBUG:${RESET} $*" >&2
}

info() {
    echo -e "${GREEN}INFO:${RESET} $*" >&2
}

error() {
    echo -e "${RED}ERROR:${RESET} $*" >&2
}

usage() {
    echo "Usage: $0 [--help] [--path PATH] [--early-exit] <PATTERN>"
    echo
    echo "  --help, -h      Show this help and exit"
    echo "  --path, -p      Path to search for packages (can be specified multiple times; defaults to current directory)"
    echo "  --early-exit, -e  Exit after finding the first matching package"
}

list_package_contents() {
    local -r package="$1"

    if [[ "$package" == *.deb ]]; then
        dpkg-deb --contents "$package"
    elif [[ "$package" == *.rpm ]]; then
        rpm -qpl "$package"
    else
        error "Unsupported package format: '$package'"
        return 1
    fi
}

list_packages_in_path() {
    local -r path="$1"

    find "$path" -type f \( -name "*.deb" -o -name "*.rpm" \)
}

find_packages_in_path_providing_pattern() {
    local -r path="$1"
    local -r pattern="$2"
    local -r early_exit="$3"

    local retval=1
    for package in $(list_packages_in_path "$path"); do
        if list_package_contents "$package" | grep -E "$pattern"; then
            info "Package '$package' provides files matching pattern '$pattern'"

            if [[ "$early_exit" == "true" ]]; then
                debug "Early exit enabled, stopping search..."
                return 0
            fi
            retval=0
        fi
    done

    return $retval
}

main() {
    local pattern=""
    local paths=()
    local early_exit="false"

    while [[ $# -gt 0 ]]; do
        case "$1" in
        --help | -h)
            usage
            exit 0
            ;;
        --path | -p)
            paths+=("$2")
            shift
            ;;
        --early-exit | -e)
            early_exit="true"
            ;;
        -*)
            error "Unexpected option: '$1'"
            exit 1
            ;;
        *)
            if [[ -z "$pattern" ]]; then
                pattern="$1"
            else
                error "Unexpected positional argument: '$1'"
                exit 1
            fi
            ;;
        esac
        shift
    done
    if [[ -z "$pattern" ]]; then
        error "No pattern specified."
        exit 1
    fi

    if [[ ${#paths[@]} -eq 0 ]]; then
        paths+=(".")
    fi

    for path in "${paths[@]}"; do
        debug "Searching for '$pattern' in '$path' ..."
        find_packages_in_path_providing_pattern "$path" "$pattern" "$early_exit"
    done
}

main "$@"
