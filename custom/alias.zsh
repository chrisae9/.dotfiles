# Custom Aliases
alias chis='ssh chis'
alias wakey="wakeonlan 74:56:3c:b6:b4:0b"
alias appleclean='find . -iname "._*" -delete'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias dotfiles='cd ~/.dotfiles'
alias dc='cd ..'
alias cx='chmod +x'
alias q='exit'
alias ssu='sudo su'
alias sse='sudoedit'
alias se='sudo vim'
alias p='python3'
alias e='vim'
alias ev='vim ~/.vimrc'
alias ez='vim ~/.zshrc'
alias eza='vim ~/.dotfiles/custom/alias.zsh'
alias eu='vim ~/.dotfiles/update'
alias uz='~/.dotfiles/update'
alias dot='cd ~/.dotfiles'
alias ezl='vim ~/.zshrc.local'
alias et='vim ~/.tmux.conf'
alias st='tmux source ~/.tmux.conf'
alias sz='source ~/.zshrc'
alias hz='vim ~/.histfile'
alias sc='vim ~/.ssh/config'

alias clear-tf="rm -rf .terraform && rm -f tfplan && rm -f .terraform.lock.hcl"

# docker
de () { docker exec -it "$@" /bin/bash; }
dee () { docker exec -it "$@" /bin/sh; }

alias dtf="docker run --rm --user $(id -u):$(id -g) -v $(pwd):/workdir hashicorp/terraform:latest fmt -recursive /workdir"
alias dcd='docker compose down'
alias dck='docker compose kill'
alias dcu='docker compose up -d'
alias dcb='docker compose build'
alias dcub='docker compose up --build -d'
dcubl() { docker compose up --build "$@" -d && docker compose logs -f "$@"; }

dcdu() { docker compose down "$@" && docker compose up -d "$@"; }
dcul() { docker compose up -d "$@" && docker compose logs -f "$@"; }
alias dcl='docker-compose logs -f'
dcdul () { docker compose down "$@" && docker compose up -d "$@" && docker compose logs -f "$@"; }

dcup() { docker compose --profile "$@" up -d; }
dcupb() { docker compose --profile "$@" up --build -d; }
dcupbl() { docker compose --profile "$@" up --build -d && docker compose --profile "$@" logs -f;}

dckp() { docker compose --profile "$@" kill; }
dcupl() { docker compose --profile "$@" up -d && docker compose --profile "$@" logs -f; }
dcdp() { docker compose --profile "$@" down; }
dclp() { docker compose --profile "$@" logs -f; }
dcdup() { docker compose --profile "$@" down && docker compose --profile "$@" up -d; }
dcdupl() { docker compose --profile "$@" down && docker compose --profile "$@" up -d && docker compose --profile "$@" logs -f; }

ollama_update() {
    ollama list | awk 'NR>1 {print $1}' | while read package; do
        echo "Updating $package..."
        ollama pull "$package"
    done
}

alias gf='git fetch'
alias gps='git push'
alias gpl='git pull'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gb='git branch'
alias gd='git diff'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gda="git for-each-ref --format '%(refname:short)' refs/heads | grep -v 'master\|main' | xargs git branch -D"
alias gstp='git stash pop'
alias gaa='git add --all'
alias gr='git reset HEAD^'
alias grh='git reset --hard HEAD'
alias grh1='git reset --hard HEAD~1'
alias gdr='echo "dry run" | gpg --clearsign'
