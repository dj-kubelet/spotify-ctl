#!/bin/bash
set -euo pipefail

ACCESS_TOKEN=$(kubectl get secrets spotify-oauth -ojsonpath='{.data.accesstoken}' | base64 --decode)

playlist_id=$1

curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
    "https://api.spotify.com/v1/playlists/$playlist_id/tracks" |
    jq -r '.items[].track.uri' |
    while read -r uri; do
        ./queue.sh "$uri"
    done
