#!/bin/sh
[ "$(uname)" != "Darwin" ] && exit 0

if osascript -e 'application "Spotify" is running' 2>/dev/null | grep -q true; then
  state=$(osascript -e 'tell application "Spotify" to player state as string')
  if [ "$state" = "playing" ]; then
    artist=$(osascript -e 'tell application "Spotify" to artist of current track')
    track=$(osascript -e 'tell application "Spotify" to name of current track')
    text="♫ $artist – $track"
    max=40
    if [ ${#text} -gt $max ]; then
      text="$(echo "$text" | cut -c1-$max)…"
    fi
    echo "$text"
  fi
fi
