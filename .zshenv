# COMMON
# zsh config dir
export ZDOTDIR=~/.config/zsh
export EDITOR=nvim
export PAGER=less
# me
export EMAIL='me@ceigh.com'
export MY_NAME='Artjom Löbsack'
# wallpaper
export WALLPAPER_TAGS=arizona

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
path+=~/.gem/ruby/2.7.0/bin
# current dir
path+=.
