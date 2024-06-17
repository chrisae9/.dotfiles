if [[ -n $commands[stern] ]]; then
    source <(stern --completion=zsh)
else
    return 1
fi

