#!/bin/bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TRACK="$*"

# Create a Kubernetes friendly name of the track search input
JOB_NAME=${TRACK// /-} # remove spaces from $TRACK
JOB_NAME=${JOB_NAME//:/-} # replace : with -
JOB_NAME=$(echo "$JOB_NAME" | tr [:upper:] [:lower:]) # lowercase
JOB_NAME=$(echo "$JOB_NAME" | LANG=c tr -cd '[:print:]') # remove non ascii characters
JOB_NAME=$(echo "$JOB_NAME" | cut -c-253) # trim to max 253 characters

kubectl create -f <(TRACK="$TRACK" JOB_NAME="$JOB_NAME" envsubst < "$DIR/job.tmpl.yaml")
