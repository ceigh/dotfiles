# plugins
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'zsh-users/zsh-completions', defer:2
zplug 'zsh-users/zsh-autosuggestions', defer:2
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
if ! zplug check; then zplug install; fi; zplug load

# completion
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt completealiases
setopt globdots
autoload -Uz compinit && compinit

# prompt
zstyle ':vcs_info:git:*' formats '%F{3}@%b%f '
setopt promptsubst
PROMPT='%F{2}%~%f ${vcs_info_msg_0_}$ '
autoload -Uz vcs_info && precmd() { vcs_info }

# history
setopt histignoredups
HISTFILE=~/.cache/zsh-history
HISTSIZE=500
SAVEHIST=500

# fix some keys
bindkey -e
bindkey '^[[H'  beginning-of-line    # Home
bindkey '^[[F'  end-of-line          # End
bindkey '^[[2~' overwrite-mode       # Insert
bindkey '^[[3~' delete-char          # Delete
bindkey '^[[5~' beginning-of-history # PageUp
bindkey '^[[6~' end-of-history       # PageDown

# aliases
alias ls='ls --color=auto'
alias l='ls -a'
alias ll='l -l'
alias v=$EDITOR
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
alias tb='nc termbin.com 9999'
