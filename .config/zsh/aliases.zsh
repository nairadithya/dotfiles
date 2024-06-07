alias ls='ls --color'
alias nv='nvim .'

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/adithya/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/adithya/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
