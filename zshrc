#####################
# CHRIS' ZSH CONFIG #
#####################

# Environment Variables
export ZSH="$HOME/.dotfiles/oh-my-zsh"
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export GPG_TTY=$(tty)
export KUBECONFIG=~/.kube/config
export HISTSIZE=10000  # Maximum number of history entries
export SAVEHIST=10000  # Number of history entries to save

zstyle ':omz:update' mode disabled

# Source Oh My Zsh
ZSH_CUSTOM=~/.dotfiles/custom
ZSH_THEME="chis"
plugins=(
    git 
    brew 
    direnv 
    kube-ps1 
    kubectl 
    kubectx 
    zsh-autosuggestions 
    emoji 
    sudo 
    aws-vault 
    nvm 
    npm 
    fluxcd 
    fzf 
    stern
    terraform
    gh
    k9s
    gpg-agent
    zsh-interactive-cd
    )

# Check if running on Steam Deck
if uname -a | grep -Eiq 'valve'; then
    plugins=(${plugins[@]/fzf})
    plugins=(${plugins[@]/zsh-interactive-cd})
fi

source $ZSH/oh-my-zsh.sh

# Paths
cdpath+=($HOME)
path+=($HOME/bin)
path+=($HOME/.local/bin)
path+=($HOME/go/bin)

# History Configuration
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate events first when trimming history
setopt HIST_FIND_NO_DUPS       # Do not display previously found event
setopt HIST_IGNORE_ALL_DUPS    # Delete old event if new is duplicate
setopt HIST_IGNORE_DUPS        # Do not record consecutive duplicate events
setopt HIST_IGNORE_SPACE       # Do not record events starting with a space
setopt HIST_SAVE_NO_DUPS       # Do not write duplicate events to history file
setopt INC_APPEND_HISTORY      # Append history incrementally
setopt SHARE_HISTORY

# Kubernetes configurations
if [[ -n $commands[kubectl] ]]; then
  alias kx='kubectx'
  alias ke='kubens'
fi

# Alias kubectl to kubecolor only if kubecolor is installed
if [[ -n $commands[kubecolor] ]]; then
  alias kubectl="kubecolor"
  compdef kubecolor=kubectl
fi

alias list-clusters='aws eks list-clusters'
alias use-cluster='aws eks --region us-east-2 update-kubeconfig --name $1'

function kc {
    clusters=($(aws eks list-clusters --output text --query 'clusters[*]'))
    if [[ -z "${clusters[*]}" ]]; then
        echo >&2 "error: could not list clusters (is the AWS CLI configured and the EKS service accessible? (VPN???))"
        return 1
    fi

    local choice
    choice=$(printf '%s\n' "${clusters[@]}" | fzf --ansi --no-preview || true)
    if [[ -z "${choice}" ]]; then
        echo >&2 "error: you did not choose any of the options"
        return 1
    else
        echo "Selected cluster: $choice"
        export SELECTED_CLUSTER=$choice
        aws eks --region us-east-2 update-kubeconfig --name "$choice"
        return 0
    fi
}

function kc_describe_last() {
  # Get the last kc command from history
  last_kc_command=$(history | grep "k get" | tail -n 1 | sed 's/^ *[0-9]* *//')

  # Replace 'get' with 'describe' in the last kc command
  new_kc_command=$(sed 's/get/describe/' <<< "$last_kc_command")

  # Print the new command to be picked up by zsh's command line
  print -z $new_kc_command
}

# Create alias 'kd' for the function
alias kd='kc_describe_last'

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi


alias start-code='sudo systemctl start code-tunnel.service'
alias stop-code='sudo systemctl stop code-tunnel.service'
alias status-code='sudo systemctl status code-tunnel.service'

# Local device specifics
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# Function to print bold messages
msg() {
    printf "$(tput bold)%s$(tput sgr0)\n" "$*"
}

# Check for internet connectivity if interactive
if [[ $- == *i* ]]; then
    if ping -c 1 -W 1 1.1.1.1 &>/dev/null; then
        ~/.dotfiles/update
    else
        msg "No/slow internet. Update script will not run."
    fi
fi
