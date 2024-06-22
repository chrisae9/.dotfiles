if [[ -z $commands[k9s] ]]; then
    return 1
fi

source <(k9s completion zsh)