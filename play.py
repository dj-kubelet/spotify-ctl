#!/usr/bin/env python

import argparse
import requests
from pprint import pprint
import time
import os


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--track-uri", help="Play a track URI")
    parser.add_argument("--search", help="Play a search result")
    args = parser.parse_args()

    if args.track_uri:
        track = args.track_uri
    if args.search:
        track = search(args.search)
    play_wait(track)


def get_auth_header():
    token = os.environ.get("ACCESS_TOKEN")
    if not token:
        with open("/tmp/accesstoken") as f:
            token = f.read()
    return {"Authorization": "Bearer " + token}


def search(query):
    url = "https://api.spotify.com/v1/search"
    params = {"q": query, "type": "track", "limit": 20}
    r = requests.get(url, params=params, headers=get_auth_header())
    j = r.json()
    pprint(j)
    tracks = j["tracks"]["items"]
    # tracks = sorted(tracks, reverse=True, key=lambda x: x["popularity"])
    for track in tracks:
        print(track["name"])
        print(track["artists"][0]["name"])
        print(track["popularity"])
    return tracks[0]["uri"]


def now_playing():
    url = "https://api.spotify.com/v1/me/player"
    r = requests.get(url, headers=get_auth_header())
    j = r.json()
    return j


def play_track(track):
    url = "https://api.spotify.com/v1/me/player/play"
    payload = {"uris": [track], "offset": {"uri": track}, "position_ms": 0}
    r = requests.put(url, headers=get_auth_header(), json=payload)


def play_wait(track):
    play_track(track)
    while True:
        time.sleep(2)
        j = now_playing()
        playing = j["is_playing"]
        uri = j["item"]["uri"]
        if playing:
            print("Playing", uri)
            print("ms left", j["item"]["duration_ms"] - j["progress_ms"])
        else:
            break
    print("Done")


if __name__ == "__main__":
    main()
