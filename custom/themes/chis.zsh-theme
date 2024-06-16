PROMPT='%{$fg[magenta]%}%~%{$reset_color%} '
RPROMPT='$(git_prompt_info)'

precmd() {
    local custom_text="$AWS_VAULT"
    
    if [[ -n "$custom_text" ]]; then
        # Get the terminal width
        local terminal_width=$(tput cols)

        # Calculate the number of spaces needed for right alignment
        local padding=$((terminal_width - ${#custom_text}))

        # Print the custom text right-aligned
        printf "%${padding}s%s\n" "" "${custom_text}"
    fi

}

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"
