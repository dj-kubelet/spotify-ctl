#!/bin/bash
set -euo pipefail

kubectl create -f <(TRACK="$*" envsubst <./job.tmpl.yaml)
