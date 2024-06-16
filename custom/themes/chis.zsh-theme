PROMPT='%{$fg[magenta]%}%~%{$reset_color%} 
$'
RPROMPT='$(git_prompt_info)'

function prompt_char {
     echo "$%{$reset_color%}" && return
    echo "≥%{$reset_color%}"
}

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"