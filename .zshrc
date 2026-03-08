# Uncomment to profile shell startup:
# zmodload zsh/zprof

# ============================================================
# Environment
# ============================================================

# Homebrew — sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, PATH, MANPATH, etc.
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export GOPATH="${GOPATH:-$HOME/dev/go}"
export PNPM_HOME="$HOME/Library/pnpm"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export GPG_TTY=$(tty)

export PATH="$HOME/bin:$GOPATH/bin:$HOME/.composer/vendor/bin:$HOME/dotfiles/scripts:$PNPM_HOME:$PATH"

# ============================================================
# History
# ============================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS   # don't record a command that is a duplicate of the previous
setopt HIST_IGNORE_SPACE  # don't record commands starting with a space
setopt SHARE_HISTORY      # share history between all sessions

# ============================================================
# Completions
# ============================================================

# Add homebrew installed zsh-completions to fpath before compinit
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)

autoload -Uz compinit
zcompdump="$HOME/.zcompdump"
# Full compinit (with compaudit) when dump is missing or older than 24h; fast -C otherwise.
# (Nmh-24): N=nullglob, m=mtime, h=hours, less than 24h old
_comp_files=("${zcompdump}"(Nmh-24))
if (( $#_comp_files )); then
  compinit -C -d "$zcompdump"
else
  compinit -d "$zcompdump"
  zcompile -R "$zcompdump" 2>/dev/null
fi
unset _comp_files

# case-insensitive completion: typing foo also matches Foo, FOO, etc.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# colors completion candidates using the same colors as ls (directories blue, executables green, etc.)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# disables zsh's built-in arrow-key completion menu. This is required for fzf-tab to take over and show completions in an fzf popup instead.
zstyle ':completion:*' menu no
# when completing cd or a zoxide path (__zoxide_z), shows a file listing preview in the fzf popup for the highlighted directory.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# ============================================================
# Plugins
# ============================================================

# $HOMEBREW_PREFIX is set by `brew shellenv` above
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.zsh"

# ============================================================
# Key bindings
# ============================================================

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# ============================================================
# Tool integrations
# ============================================================

eval "$(starship init zsh)"
# disable ctrl-r default binding, because atuin will take over and show history search in an fzf popup instead.
FZF_CTRL_R_COMMAND= source <(fzf --zsh)
eval "$(zoxide init zsh --cmd cd)"
eval "$(atuin init zsh)"

# ============================================================
# Aliases
# ============================================================

alias reload="source ~/.zshrc"
alias cat="bat"
alias catp="bat --style=plain"
alias ls="eza"
alias la="eza --long --all --group"
alias c="clear"
alias terraform="tofu"
alias tf="tofu"
alias lg="lazygit"
alias fuck='if ! declare -f fuck &>/dev/null; then eval -- "$(thefuck -a)"; fi && fuck'
alias f="fuck"

# changing dir
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
# listing dir
alias l='ls -lah'
alias ll='ls -lh'

# git
alias gst='git status'
alias gsw='git switch'
alias gco='git checkout'
alias ga='git add'
alias gaa='git add --all'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'

# ============================================================
# Functions
# ============================================================

source_if_exists() {
  [[ -r $1 ]] && source "$1"
}

# use tldr and if it failes, use man as fallback
man() { 
  tldr "$@" 2>/dev/null || command man "$@"; 
}

# Delete local branches already merged into main/master/develop
gcmb() {
  git fetch --prune origin
  git branch --merged | grep -Ev '^\*|main|master|develop' | xargs git branch --delete
}

# opens an interactive directory picker with fzf
z() {
  if [[ $# -eq 0 ]]; then
    cd "$(zoxide query -ls | fzf --preview 'eza -1 {}' --height 40% | awk '{print $2}')"
  else
    zoxide query "$@" | read dir && cd "$dir"
  fi
}

# ============================================================
# Local overrides
# ============================================================

source_if_exists ~/.config/zsh/private.zsh
source_if_exists ~/.config/zsh/work.zsh

# Uncomment to print profiler output:
# zprof
