#!/usr/bin/env sh
readonly PID_FILE=/run/user/$UID/nts.pid

run() {
  [ -f $PID_FILE ] &&
    echo "Is running. Try 'nts end' or delete ${PID_FILE}" &&
    exit 1

  local -r STREAM_URL=https://stream-relay-geo.ntslive.net/stream
  mpv --really-quiet "${STREAM_URL}${1}" &
  echo $! > $PID_FILE
}

end() {
  [ -f $PID_FILE ] && kill $(cat $PID_FILE)
  rm --force $PID_FILE
}

[ -z $1 ] && do=run || do=$1
[ "$do" != run ] && [ "$do" != end ] &&
  echo "You can only 'run' or 'end'. You provide: '${do}'." &&
  exit 1

ch=$2
[ "$ch" = 1 ] && ch=
[ -n "$ch" ] && [ "$ch" != 2 ] &&
  echo "Channel can be '' or '1' or '2'. You provide: '${ch}'." &&
  exit 1

[ "$do" = run ] && run $ch && exit 0
[ "$do" = end ] && end && exit 0
