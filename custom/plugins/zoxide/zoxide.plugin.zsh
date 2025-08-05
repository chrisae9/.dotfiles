if [[ -n $commands[zoxide] ]]; then
    eval "$(zoxide init zsh)"
else
    return 1
fi