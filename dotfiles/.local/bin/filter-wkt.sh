#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o noclobber

INPUT="${1:--}"

grep -Poi '(LINESTRING|POINT|POLYGON)\s*Z?\s*\(.*?\)+' "$INPUT"
