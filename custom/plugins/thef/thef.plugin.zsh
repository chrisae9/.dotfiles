if [[ -n $commands[thefuck] ]]; then
    alias f="fuck"
else
    return 1
fi

# Register alias
[[ ! -a $ZSH_CACHE_DIR/thefuck ]] && thefuck --alias > $ZSH_CACHE_DIR/thefuck
source $ZSH_CACHE_DIR/thefuck

fuck-command-line() {
    local FUCK="$(THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)"
    [[ -z $FUCK ]] && echo -n -e "\a" && return
    BUFFER=$FUCK
    zle end-of-line
}
zle -N fuck-command-line
# Defined shortcut keys: [Esc] [f]
bindkey -M emacs '\ef' fuck-command-line
bindkey -M vicmd '\ef' fuck-command-line
bindkey -M viins '\ef' fuck-command-line

