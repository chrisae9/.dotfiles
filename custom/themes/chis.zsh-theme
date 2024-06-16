PROMPT='%{$fg[magenta]%}%~%{$reset_color%} $(extra)$ '
RPROMPT='$(git_prompt_info)'

function extra {
PROMPT+='$AWS_VAULT
'
}

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"