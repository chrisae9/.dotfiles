if [[ -n $commands[gh] ]]; then
    source <(gh completion -s zsh)
    eval "$(gh copilot alias -- zsh)"
else
    return 1
fi

alias ghe="ghce"
alias ghs="ghcs"
alias ghc="gh copilot config"
alias ghci="gh extension install github/gh-copilot"
