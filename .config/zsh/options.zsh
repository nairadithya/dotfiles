# History Configuration
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

# Changing completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Adding fzf styling
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Changing to vim keybinds
bindkey -v

export VISUAL=nvim
export EDITOR=nvim
