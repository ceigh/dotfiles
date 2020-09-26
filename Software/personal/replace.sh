#!/usr/bin/env sh
[ -z $1 ] && echo 'No expression to replace' && exit 1 || IF=$1
[ -z $2 ] && OF='' || OF=$2

rg -l $IF | xargs -d '\n' sed -i 's@'"$IF"'@'"$OF"'@g' && \
  rg $OF
