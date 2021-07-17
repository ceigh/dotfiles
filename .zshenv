# COMMON
# zsh config dir
export ZDOTDIR=~/.config/zsh

export EDITOR=nvim
export DIFFPROG="$EDITOR -d"
export PAGER=less
export EMAIL='me@ceigh.com'
export MY_NAME='Artjom Löbsack'
export GPG_TTY=$(tty)

# PATH
# npm
path+=~/.node_modules/bin
export npm_config_prefix=~/.node_modules
# local
path+=~/.local/bin
# yarn
path+=(~/.yarn/bin ~/.config/yarn/global/node_modules/.bin)
# cargo
path+=~/.cargo/bin
# gems
path+=~/.gem/ruby/3.0.0/bin
# current dir
path+=.
