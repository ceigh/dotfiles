#!/usr/bin/env sh
[ -z $1 ] && echo Specify directory! && exit 1 || DIR=$1

keep() {
  echo "zsh -c '$1; exec zsh'"
}

gnome-terminal --maximize --working-directory=$DIR \
  --window -t Editor \
  -e "$(keep 'v package.json +NERDTreeToggle')" \
  \
  --tab -t History --active \
  -e "$(keep page)" \
  \
  --tab -t Debug \
  -e "$(keep 'yarn dev')"
