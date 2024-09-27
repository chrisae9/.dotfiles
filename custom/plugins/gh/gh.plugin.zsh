if [[ -n $commands[gh] ]]; then
    source <(gh completion -s zsh)
else
    return 1
fi

eval "$(gh copilot alias -- zsh)"


alias ghe="ghce"
alias ghs="ghcs"
alias ghc="gh copilot config"
alias ghci="gh extension install github/gh-copilot"
