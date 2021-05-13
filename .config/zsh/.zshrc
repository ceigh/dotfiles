# completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt COMPLETE_ALIASES
_comp_options+=(globdots) # for hidden files

# vi mode
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

# prompt
autoload -Uz vcs_info && precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{3}@%b%f '
setopt PROMPT_SUBST
PROMPT='%F{2}%~%f ${vcs_info_msg_0_}$ '

# history
setopt HIST_IGNORE_DUPS
HISTFILE=~/.cache/zsh-history
HISTSIZE=500
SAVEHIST=500

# fix some keys
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

# misc
  # https://github.com/ohmyzsh/ohmyzsh/issues/31
unsetopt nomatch

# plugins
  # inline suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#444444'
  # syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
