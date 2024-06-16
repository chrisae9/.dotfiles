# Define color variables
COLOR_MAGENTA='%{$fg[magenta]%}'
COLOR_BOLD_BLUE='%{$fg_bold[blue]%}'
COLOR_RED='%{$fg[red]%}'
COLOR_GREEN='%{$fg[green]%}'
COLOR_RESET='%{$reset_color%}'

# Set the main prompt to show the current directory in magenta
PROMPT="${COLOR_MAGENTA}%~${COLOR_RESET} "

# Set the right prompt to show Git information in bold blue
RPROMPT="${COLOR_BOLD_BLUE}$(git_prompt_info)${COLOR_RESET}"

# Customize Git prompt information
ZSH_THEME_GIT_PROMPT_PREFIX="${COLOR_BOLD_BLUE}(${COLOR_RESET}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${COLOR_BOLD_BLUE})${COLOR_RESET}"
ZSH_THEME_GIT_PROMPT_DIRTY="${COLOR_RED}✗${COLOR_RESET}"
ZSH_THEME_GIT_PROMPT_CLEAN="${COLOR_GREEN}✔${COLOR_RESET}"