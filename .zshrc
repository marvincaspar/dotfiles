# zmodload zsh/zprof


source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}


if [[ -f "/opt/homebrew/bin/brew" && $- == *l* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZDOTDIR="${HOME}/.antidote"

# Download Zinit, if it's not there yet
if [ ! -d "$ZDOTDIR" ]; then
   git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR}
fi

# Speed up compinit by caching
autoload -Uz compinit
zcompdump="$HOME/.zcompdump"
# Only recompile if needed
if [[ ! -s $ZSH_COMPDUMP.zwc || $ZSH_COMPDUMP -nt $ZSH_COMPDUMP.zwc ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
  zcompile ~/.zcompdump
else
  source "$ZSH_COMPDUMP.zwc"
fi


# Source/Load antidote
source "${ZDOTDIR}/antidote.zsh"


# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=$HOME/.config/antidote/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=(/path/to/antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh



# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# Shell integrations
export STARSHIP_CONFIG=~/.config/starship/starship.toml
alias fuck='if ! declare -f fuck &>/dev/null; then eval -- "$(thefuck -a)"; fi && fuck'

eval "$(starship init zsh)"
zsh-defer eval "$(fzf --zsh)"
zsh-defer eval "$(zoxide init zsh --cmd cd)"
zsh-defer eval "$(atuin init zsh)"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

export GOPATH="${GOPATH:-$HOME/dev/go}"
export PATH="$HOME/bin:/usr/local/bin:$GOPATH/bin:$HOME/.composer/vendor/bin/:$HOME/dotfiles/scripts:$PATH"


# git clean up merged branches
gcmb() {
  git fetch --prune origin

  git branch --merged | egrep -v "(^\*|main|master|develop)" | xargs git branch --delete
}

gif() {
    # Based on https://gist.github.com/SheldonWangRJT/8d3f44a35c8d1386a396b9b49b43c385
    output_file="$1.gif"
    ffmpeg -y -i $1 -v quiet -pix_fmt rgb8 -r 10 $output_file && gifsicle -O3 $output_file -o $output_file
}

alias reload="source ~/.zshrc"
alias f="fuck"
alias cat="bat"
alias catp="bat --style=plain"
alias ls="eza"
alias la="eza --long --all --group"
alias man="tldr"
alias c="clear"
alias terraform="tofu"
alias tf="tofu"
alias lg="lazygit"


# Custom config for work which I don't want to publish
source_if_exists ~/.config/zsh/private.zsh
source_if_exists ~/.config/zsh/work.zsh


# The following lines have been added by Docker Desktop to enable Docker CLI completions.
# fpath=(/Users/marvincaspar/.docker/completions $fpath)
# autoload -Uz compinit
# compinit
# End of Docker CLI completions

# zprof
