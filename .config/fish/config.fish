starship init fish | source
set -U fish_greeting
# uv
export PATH="/home/adithya/.local/bin:$PATH"
# bun binaries
export PATH="/home/adithya/.bun/bin:$PATH"
# personal binaries
export PATH="/home/adithya/bin:$PATH"

# Aliases
alias xo='xdg-open'
alias ls='ls --color'

# Emacs aliases
set emacs_alias = 'emacsclient -t'

alias ec=$emacs_alias 
alias nvim=$emacs_alias
alias vim=$emacs_alias
alias vi=$emacs_alias

# Emacs vterm config
function vterm_printf;
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end
