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
HISTFILE=~/.cache/.zsh_history
HISTSIZE=100
SAVEHIST=200

# FIX SOME KEYS
bindkey '^[[H'  beginning-of-line    # Home
bindkey '^[[F'  end-of-line          # End
bindkey '^[[2~' overwrite-mode       # Insert
bindkey '^[[3~' delete-char          # Delete
bindkey '^[[5~' beginning-of-history # PageUp
bindkey '^[[6~' end-of-history       # PageDown

# ALIASES
alias ls='ls --color'
alias l='ls -a'
alias ll='l -l'
alias v=$EDITOR
alias m=$PAGER
alias xrdbm='xrdb -merge ~/.Xresources'
# git
alias gs='git status'
alias gf='git diff'
alias ga='git add'
alias gm='git commit -m'
alias gl='git log --oneline'
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
alias te='translate -f ru -t en'
alias tr='translate -f en -t ru'
# fit feh image size
alias feh='feh --scale-down --auto-zoom'

# PLUGINS
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#777'
