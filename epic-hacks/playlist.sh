#!/bin/bash
set -euo pipefail

ACCESS_TOKEN=$(kubectl get secrets spotify-oauth -ojsonpath='{.data.access_token}' | base64 --decode)

# Remove "spotify:playlist:" from the input if present
playlist_id=${1/spotify:playlist:/}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
    "https://api.spotify.com/v1/playlists/$playlist_id/tracks" |
    jq -r '.items[].track.uri' |
    while read -r uri; do
        "$DIR/queue.sh" "$uri"
    done
