#!/usr/bin/env sh
[ -z $1 ] && CHAN='' || CHAN=$1
mpv "https://stream-relay-geo.ntslive.net/stream${CHAN}"
