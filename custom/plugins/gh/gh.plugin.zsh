if [[ -n $commands[gh] ]]; then
    source <(gh completion -s zsh)
else
    return 1
fi