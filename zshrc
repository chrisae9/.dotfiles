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
    terraform
    gh
    k9s
    gpg-agent
    zsh-interactive-cd
    ollama
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

c() {
    if [[ $# -eq 0 ]]; then
        code --reuse-window .
    else
        code "$@"
    fi
}

ci() {
    if [[ $# -eq 0 ]]; then
        code-insiders --reuse-window .
    else
        code-insiders "$@"
    fi
}

cu() {
    if [[ $# -eq 0 ]]; then
        cursor --reuse-window .
    else
        cursor "$@"
    fi
}
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
use-cluster() {
    aws eks --region us-east-2 update-kubeconfig --name "$1"
}

# Function to fetch and display active colors from cluster URLs
cluster-color() {
    echo "Fetching active colors from clusters:"
    for url in \
        "https://cluster.nonprod.cloudy.sonatype.dev/" \
        "https://cluster.cloudy.sonatype.dev/" \
        "https://cluster.dev.cloudy.sonatype.dev/"; do

        colour=$(curl -s -m 5 "$url" | jq -r '.colour // "unknown"' 2>/dev/null || echo "unknown")
        echo "$url: $colour"
    done
}

kc() {
    # Fetch and display colors
    cluster-color

    # Define the list of regions
    regions=(
        #us-east-1
        us-east-2
        #us-west-1
        us-west-2
        eu-central-1
        eu-west-1
        #eu-west-2
    )

    # Select AWS Region
    selected_region=$(printf '%s\n' "${regions[@]}" | fzf --prompt="Select AWS Region: " --height 40% --border --ansi)
    [[ -z "$selected_region" ]] && { echo >&2 "Error: No region selected"; return 1; }
    echo "Selected region: $selected_region"

    # List clusters and select one
    clusters=$(aws eks list-clusters --region "$selected_region" --output json | jq -r '.clusters[]')
    [[ -z "$clusters" ]] && { echo >&2 "Error: No clusters found in region '$selected_region'"; return 1; }

    choice=$(echo "$clusters" | fzf --prompt="Select EKS Cluster: " --height 40% --border --ansi --no-preview)
    [[ -z "$choice" ]] && { echo >&2 "Error: No cluster selected"; return 1; }
    echo "Selected cluster: $choice in region: $selected_region"

    export SELECTED_CLUSTER="$choice"
    export SELECTED_REGION="$selected_region"
    aws eks --region "$selected_region" update-kubeconfig --name "$choice"
}

kc_describe_last() {
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
