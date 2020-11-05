# COMPLETION
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt COMPLETE_ALIASES
_comp_options+=(globdots) # for hidden files

# PROMPT
autoload -Uz vcs_info && precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{3}@%b%f '
setopt PROMPT_SUBST
PROMPT='%F{2}%~%f ${vcs_info_msg_0_}$ '

# HISTORY
setopt HIST_IGNORE_DUPS
mkdir -p ~/.cache/zsh
HISTFILE=~/.cache/zsh/history
HISTSIZE=500
SAVEHIST=500

# KEYS
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
alias gh='git push'
# dotfiles
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cs='config status'
alias cf='config diff'
alias ca='config add'
alias cm='config commit -m'
alias cl='config log --oneline'
alias ch='config push'

# MISC
# remember directory on new tab
# . /etc/profile.d/vte.sh
# remove matches
# https://github.com/ohmyzsh/ohmyzsh/issues/31
unsetopt nomatch
# window title
print -n '\e]2;Shell\a'
