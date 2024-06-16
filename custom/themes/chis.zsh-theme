PROMPT='%{$fg[blue]%}[%{$reset_color%}%{$fg[magenta]%}%~%{$reset_color%}%{$fg[blue]%}]%{$reset_color%}$(extra)
 %{$fg[blue]%}>%{$reset_color%} %{$reset_color%}'
RPROMPT='%{$reset_color%}$(git_prompt_info)%{$reset_color%}'

function extra {
    if [[ -n "$AWS_VAULT" ]]; then
        echo "%{$fg[yellow]%}[%{$reset_color%}%{$fg[red]%}$AWS_VAULT%{$reset_color%}%{$fg[yellow]%}]%{$reset_color%} $(kube_ps1)%{$reset_color%}"
    fi
}

function get_cluster_short() {
    echo "$1" | cut -d ':' -f6 | cut -d '/' -f2
}

KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
KUBE_PS1_PREFIX_COLOR="yellow"
KUBE_PS1_SUFFIX_COLOR="yellow"
KUBE_PS1_PREFIX="["
KUBE_PS1_SUFFIX="]"

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"