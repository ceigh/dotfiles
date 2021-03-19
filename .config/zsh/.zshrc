# COMPLETION
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt COMPLETE_ALIASES
_comp_options+=(globdots) # for hidden files

# VI MODE
bindkey -v
KEYTIMEOUT=1
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd) vi_mode=N; echo -ne '\e[1 q';;
    viins|main) vi_mode=I; echo -ne '\e[5 q';;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# PROMPT
autoload -Uz vcs_info && precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{3}@%b%f '
setopt PROMPT_SUBST
PROMPT='%F{2}%~%f ${vcs_info_msg_0_}${vi_mode} $ '

# HISTORY
setopt HIST_IGNORE_DUPS
mkdir -p ~/.cache/zsh
HISTFILE=~/.cache/zsh/history
HISTSIZE=500
SAVEHIST=500

# FIX SOME KEYS
bindkey '\e[H'  beginning-of-line    # Home
bindkey '\e[4~' end-of-line          # End
bindkey '\e[4h' overwrite-mode       # Insert
bindkey '\e[P'  delete-char          # Delete
bindkey '\e[5~' beginning-of-history # PageUp
bindkey '\e[6~' end-of-history       # PageDown

# ALIASES
alias ls='ls --color=auto'
alias la='ls -a'
alias swap-clean='sudo swapoff -a && sudo swapon -a'
alias wifi-monitor='nmcli d wifi'
alias node-bind='sudo setcap cap_net_bind_service=+ep `readlink -f \`which node\``'
alias v=nvim
alias xe='rg -e "\((WW|EE)\)" ~/.local/share/xorg/Xorg.0.log'
# git
alias gs='git status'
alias gf='git diff'
alias ga='git add'
alias gm='git commit -m'
alias gl='git log --oneline'
alias gc='git checkout .'
alias gh='git push'
alias gha='git remote | xargs -L1 git push --all'
# dotfiles
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cs='config status'
alias cf='config diff'
alias ca='config add'
alias cm='config commit -m'
alias cl='config log --oneline'
alias ch='config push'
alias cha='config remote | xargs -L1 git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME push --all'
# translate
alias t='trans'
alias tr='trans :ru'
# fit size
alias feh='feh --scale-down --auto-zoom'
# show diskspace
alias dfh='df -h | rg /$'

# MISC
# remember directory on new tab
# . /etc/profile.d/vte.sh
# remove matches
# https://github.com/ohmyzsh/ohmyzsh/issues/31
unsetopt nomatch
# window title
print -n '\e]2;Shell\a'

# PLUGINS
# inline suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#444444'
# syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
