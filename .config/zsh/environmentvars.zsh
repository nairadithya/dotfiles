# Setup fzf
# ---------
if [[ ! "$PATH" == *${FZF_PATH}/bin* ]]; then
	path+=("${FZF_PATH}/bin")
fi
# >>> juliaup initialize >>>
# !! Contents within this block are managed by juliaup !!
case ":$PATH:" in
    *:/home/adithya/.juliaup/bin:*)
        ;;

    *)
	    path+=(/home/adithya/.juliaup/bin)
        ;;
esac
# <<< juliaup initialize <<<
path+=("$HOME/Builds/swww/target/release/")
path+=("$HOME/.tmux/plugins/tmuxifier/bin/")
path+=("$HOME/bin/")
path+=("$HOME/.local/bin/")
export BUN_INSTALL="$HOME/.bun"
path+=("$BUN_INSTALL/bin")
export VISUAL=nvim
export EDITOR=nvim
eval "$(tmuxifier init -)"
export PATH
