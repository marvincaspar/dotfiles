# zmodload zsh/zprof


source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}


if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZDOTDIR="${HOME}/.antidote"

# Download Zinit, if it's not there yet
if [ ! -d "$ZDOTDIR" ]; then
   git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR}
fi

# Load completions
autoload -Uz compinit && compinit

# Source/Load antidote
source "${ZDOTDIR}/antidote.zsh"
antidote load $HOME/.config/antidote/.zsh_plugins.txt

# if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
#   eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/omp.toml)"
# fi


export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"


# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region



# Use if not using atuin
# # History
# HISTSIZE=5000
# HISTFILE=~/.zsh_history
# SAVEHIST=$HISTSIZE
# HISTDUP=erase
# setopt appendhistory
# setopt sharehistory
# setopt hist_ignore_space
# setopt hist_ignore_all_dups
# setopt hist_save_no_dups
# setopt hist_ignore_dups
# setopt hist_find_no_dups

# Shell integrations
eval "$(fzf --zsh)"
eval "$(thefuck --alias)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(atuin init zsh)"


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

export GOPATH=$HOME/dev/go
export PATH=$HOME/bin:/usr/local/bin:$(go env GOPATH)/bin:$HOME/dotfiles/scripts:$PATH


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

alias f="fuck"
alias cat="bat"
alias catp="bat --style=plain"
alias ls="eza"
alias la="eza --long --all --group"
alias man="tldr"
alias c="clear"
alias terraform="tofu"
alias tf="tofu"


# Custom config for work which I don't want to publish
source_if_exists ~/.config/zsh/work.zsh


# zprof