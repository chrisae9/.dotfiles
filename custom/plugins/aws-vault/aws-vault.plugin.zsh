if [[ -n $commands[aws-vault] ]]; then
    alias av="aws-vault"
    source <(aws-vault --completion-script-zsh)
else
    return 1
fi

alias ac='vim ~/.aws/config'
alias avu='unset AWS_VAULT'

# https://github.com/99designs/aws-vault/blob/master/contrib/completions/zsh/aws-vault.zsh

function avp {
    profiles=($(aws-vault list | awk 'NR>2 {print $1}'))
    if [[ -z "${profiles[*]}" ]]; then
        echo >&2 "error: could not list profiles (is aws-vault installed and configured?)"
        return 1
    fi

    local choice
    choice=$(printf '%s\n' "${profiles[@]}" | fzf --ansi --no-preview || true)
    if [[ -z "${choice}" ]]; then
        echo >&2 "error: you did not choose any of the options"
        return 1
    else
        echo "Selected profile: $choice"
        export SELECTED_PROFILE=$choice
        aws-vault exec $choice
        return 0
    fi
}

if [[ "$(basename -- ${(%):-%x})" != "_aws-vault" ]]; then
    compdef _aws-vault aws-vault
fi
