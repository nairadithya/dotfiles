# Adding ZINIT
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"


# Adding syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting

# Adding autocomplete
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit

# Adding autosuggestions
zinit light zsh-users/zsh-autosuggestions

bindkey '^f' autosuggest-accept


# FZF-ZSH plugin
zinit light unixorn/fzf-zsh-plugin
zinit light Aloxaf/fzf-tab

# Clipboard plugin
zinit light twang817/zsh-clipboard
