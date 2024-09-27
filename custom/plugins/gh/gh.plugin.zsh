if [[ -n $commands[gh] ]]; then
    source <(gh completion -s zsh)
else
    return 1
fi

if gh extension list | grep -q 'gh-copilot'; then
    eval "$(gh copilot alias -- zsh)"
fi


alias ghe="ghce"
alias ghs="ghcs"
alias ghc="gh copilot config"
alias ghci="gh extension install github/gh-copilot"
