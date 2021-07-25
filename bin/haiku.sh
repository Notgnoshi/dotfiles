#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

usage() {
    echo "$0 -- Query https://agill.xyz/generate for GPT-2 generated haiku"
    echo ""
    echo "Usage:"
    echo ""
    echo "--help,-h        This help output"
    echo "--prompt,-p      The prompt to start the haiku with"
    echo "--seed,-s        The random seed for reproducibility"
    echo "--number,-n      The number of haiku to generate"
    echo "--temperature,-t The generation temperature"
    echo "--max_tokens,-m  The maximum number of tokens to generate"
}

LONGOPTS=prompt:,seed:,number:,temperature:,max_tokens:,help
OPTIONS=p:s:n:t:m:h

# Use '!' to ignore errexit so we can print the usage statement.
! PARSED=$(getopt --options="$OPTIONS" --longoptions="$LONGOPTS" --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    usage
    exit 2
fi
eval set -- "$PARSED"

PROMPT=""
SEED=""
NUMBER=5
TEMPERATURE=1
MAX_TOKENS=20

while [ $# -ge 1 ]; do
    case "$1" in
    --)
        shift
        break
        ;;
    -p | --prompt)
        PROMPT="$2"
        shift
        ;;
    -s | --seed)
        SEED="$2"
        shift
        ;;
    -n | --number)
        NUMBER="$2"
        shift
        ;;
    -t | --temperature)
        TEMPERATURE="$2"
        shift
        ;;
    -m | --max_tokens)
        MAX_TOKENS="$2"
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift
done

# The quoting and array expansion here was a bitch to get right.
CURL_PROMPT=()
if [ -n "$PROMPT" ]; then
    CURL_PROMPT=(--data-urlencode "prompt=$PROMPT")
fi
CURL_SEED=()
if [ -n "$SEED" ]; then
    CURL_SEED=(--data-urlencode "seed=$SEED")
fi

curl \
    --silent \
    --show-error \
    --get \
    --write-out "%{stderr}%{url_effective}\n" \
    "${CURL_PROMPT[@]}" \
    "${CURL_SEED[@]}" \
    --data-urlencode "number=$NUMBER" \
    --data-urlencode "temperature=$TEMPERATURE" \
    --data-urlencode "k=0" \
    --data-urlencode "p=0.9" \
    --data-urlencode "max_tokens=$MAX_TOKENS" \
    "https://agill.xyz/generate" |
    jq
