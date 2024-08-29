if [[ -n $commands[aws-vault] ]]; then
    alias av="aws-vault"
else
    return 1
fi

alias ac='vim ~/.aws/config'
alias avu='unset AWS_VAULT'

# https://github.com/99designs/aws-vault/blob/master/contrib/completions/zsh/aws-vault.zsh

_aws-vault() {
    local i
    for (( i=2; i < CURRENT; i++ )); do
        if [[ ${words[i]} == -- ]]; then
            shift $i words
            (( CURRENT -= i ))
            _normal
            return
        fi
    done

    local matches=($(${words[1]} --completion-bash ${(@)words[2,$CURRENT]}))
    compadd -a matches

    if [[ $compstate[nmatches] -eq 0 && $words[$CURRENT] != -* ]]; then
        _files
    fi
}

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
