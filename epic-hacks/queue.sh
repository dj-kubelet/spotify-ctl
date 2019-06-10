#!/bin/bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

kubectl create -f <(TRACK="$*" envsubst < "$DIR/job.tmpl.yaml")
