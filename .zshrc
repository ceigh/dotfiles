# COMPINSTALL
zstyle :compinstall filename '/home/ceigh/.zshrc'
autoload -Uz compinit
compinit

# colors
autoload -U colors && colors

# history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

# tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # hidden files

# keys
bindkey '\e[H' beginning-of-line # Home
bindkey '\e[F' end-of-line # End
bindkey '\e[2~' overwrite-mode # Insert
bindkey '\e[3~' delete-char # Delete
bindkey '\e[5~' beginning-of-history #PageUp
bindkey '\e[6~' end-of-history #PageDown

# prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{185}(%b)%f '
setopt PROMPT_SUBST
PROMPT='%F{6}%n%f%F{6}@%f%F{6}%m%f %F{69}%~%f ${vcs_info_msg_0_}$ '

# aliases
alias ls='ls --color=auto'
alias swap-clean='sudo swapoff -a && sudo swapon -a'
alias wifi-monitor='nmcli d wifi'
alias node-bind='sudo setcap cap_net_bind_service=+ep `readlink -f \`which node\``'
alias my-name='echo "Artjom Löbsack"'
alias page='git --no-pager log --oneline -n 20'
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# to complete filenames on aliases
setopt completealiases

# remember directory on new tab
. /etc/profile.d/vte.sh

# PATH
# local
path+=~/.local/bin

# npm
path+=~/.node_modules/bin
export npm_config_prefix=~/.node_modules

# yarn
path+=~/.yarn/bin
path+=~/.config/yarn/global/node_modules/.bin

# cargo
path+=~/.cargo/bin
