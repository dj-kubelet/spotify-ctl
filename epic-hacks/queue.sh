#!/bin/bash
set -euo pipefail

# Create a Kubernetes friendly name of the track search input
normalize_str() {
    S=${1// /-}                                 # remove spaces from $1
    S=${S//:/-}                                 # replace : with -
    S=$(echo "$S" | tr "[:upper:]" "[:lower:]") # lowercase
    S=$(echo "$S" | LANG=c tr -cd '[:print:]')  # remove non ascii characters
    S=$(echo "$S" | cut -c-253)                 # trim to max 253 characters
    echo "$S"
}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

declare -x TRACK
TRACK="$*"

declare -x POD_NAME
POD_NAME="$(normalize_str "$TRACK")"

envsubst <"$DIR/pod.tmpl.yaml" | kubectl create -f -
