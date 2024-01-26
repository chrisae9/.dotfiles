#####################
# CHRIS' ZSH CONFIG #
#####################
#

# HOMEBREW completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

#COMPINSTALL
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit; autoload -U colors && colors; compinit

if command -v direnv >/dev/null 2>&1; then
    # If 'direnv' is installed, run the hook
    eval "$(direnv hook zsh)"
fi

# source <(kubectl completion zsh)

#PATH
setopt auto_cd
cdpath+=($HOME)
cdpath+=(/hdd)
path+=($HOME/bin)
path+=($HOME/.local/bin)
path+=($HOME/go/bin)

#ENVIRONMENT VARIABLES
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export GPG_TTY=$(tty)
export KUBECONFIG=~/.kube/config


#BINDS
bindkey "^R" history-incremental-search-backward #ctrl+r search through zsh history
bindkey -e

#################
# ALIAS SECTION #
#################

#WAKE ON LAN
alias wakey='wakeonlan 04:92:26:d8:07:73'

##SSH
alias chis='ssh chis'
alias appleclean='find . -iname "._*" -delete'

##LS
if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

#directory operations
alias dot='cd $HOME/.dotfiles'
alias c='cd'
alias dc='cd ..'
alias pu='pushd'
alias po='popd'
alias cx='chmod +x'
alias q='exit'

#sudo
alias ssu='sudo su'
alias sse='sudoedit'

#EDITING
alias se='sudo vim'
alias ee=' emacs -nw'
alias e='vim'
alias v='vim'
alias vi='vim'
alias vim='vim'
alias p='python3'
alias ev='vim ~/.vimrc'
alias ez='vim ~/.zshrc'
alias uz='~/.dotfiles/update'
alias ezl='vim ~/.zshrc.local'
alias sz='source ~/.zshrc'
alias hz='vim ~/.histfile'
alias sc='vim ~/.ssh/config'

#DOCKER
alias dcd='docker compose down'
alias dck='docker compose kill'
alias dcu='docker compose up -d'
alias dcdu='docker compose down && docker compose up -d'


dcuf() {
        docker-compose -f "$1" up -d
}

dcdf() {
        docker-compose -f "$1" down
}

#vscode
alias code='code -r .'

#AWS//KUBECTL
alias kubectl='kubecolor'
alias kc='kubectl'
alias kx='kubectx'
alias ke='kubens'
alias list-clusters='aws eks list-clusters'
alias use-cluster='aws eks --region us-east-2 update-kubeconfig --name $1'

#GIT
alias gf='git fetch'
alias gp='git push'
alias gl='git pull'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gb='git branch'
alias gd='git diff'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gda="git for-each-ref --format '%(refname:short)' refs/heads | grep -v "master\|main" | xargs git branch -D"
alias gstp'git stash pop'
alias gaa='git add --all'
alias gr='git reset HEAD^'
alias grh='git reset --hard HEAD'
alias grh1='git reset --hard HEAD~1'
alias gdr='echo "dry run" | gpg --clearsign'

#OTHER
alias javaselect='sudo update-alternatives --config java'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

if [[ "$(uname)" == "Darwin" ]]; then
    alias du='du -hd1'
else
    alias du='du -h --max-depth=1'
fi

#TERMINAL COLOR
PROMPT="%F{yellow}($SHLVL)%f %F{61}$USERNAME%f%F{silver}|%f%F{cyan}%~%f%F{silver}|%f%F{61}$%f " 


#SAVE COMMAND HISTORY
setopt HIST_IGNORE_SPACE
export HISTSIZE=10000  # history size
export SAVEHIST=10000  # history size after logout
export HISTFILE=$HOME/.histfile
setopt INC_APPEND_HISTORY  # Append into history
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY  # Save timestamp for history entries


#USE .zshrc.local 
#FOR LOCAL DEVICE SPECIFICS
if [[ -f "$HOME"/.zshrc.local ]]
then
    source $HOME/.zshrc.local
fi

msg() {
    printf "$(tput bold)%s$(tput sgr0)\n" "$*"
}

if [[ $- == *i* ]]; then
    # If interactive, then check for internet connectivity
    if ping -c 1 -W 1 1.1.1.1 &> /dev/null; then
        # Run the update script if connected
        ~/.dotfiles/update
    else
        # Warn if unable to connect
        msg "No/slow internet. Update script will not run."
    fi
fi
