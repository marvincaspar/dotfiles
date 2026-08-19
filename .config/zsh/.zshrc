# Uncomment to profile shell startup:
# zmodload zsh/zprof


# =========================================================
# Environment
# =========================================================


# Homebrew — sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, PATH, MANPATH, etc.
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# =========================================================
# History
# =========================================================


HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY     # share history between all sessions
setopt HIST_IGNORE_DUPS # don't record a command that is a duplicate of the previous
setopt HIST_IGNORE_SPACE # don't record commands starting with a space
setopt HIST_EXPIRE_DUPS_FIRST # when HISTFILE exceeds HISTSIZE, remove duplicates first to reduce file size
setopt HIST_FIND_NO_DUPS # don't display duplicates in history search results


# =========================================================
# Shell behaviour
# =========================================================


setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1


# =========================================================
# Completion
# =========================================================


[[ -d /Users/marvincaspar/.docker/completions ]] && fpath=(/Users/marvincaspar/.docker/completions $fpath)

# Deduplicate fpath (brew shellenv, docker, and plugins can add the same dirs multiple times)
typeset -U fpath

# Load completion system
autoload -Uz compinit

# Initialize completion with cached metadata file.
# Use -C (skip audit + skip redump) when the dump is <24h old — this avoids
# the 5s compinit penalty on every shell start.
# Note: (N.mh+24) glob inside [[ ]] requires EXTENDED_GLOB; use stat instead.
local _zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
mkdir -p "${_zcompdump:h}"
if [[ ! -f "$_zcompdump" ]] || (( $(stat -f %m "$_zcompdump") < EPOCHSECONDS - 86400 )); then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# case-insensitive completion: typing foo also matches Foo, FOO, etc.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# colors completion candidates using the same colors as ls (directories blue, executables green, etc.)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# disables zsh's built-in arrow-key completion menu. This is required for fzf-tab to take over and show completions in an fzf popup instead.
zstyle ':completion:*' menu no
# when completing cd or a zoxide path (__zoxide_z), shows a file listing preview in the fzf popup for the highlighted directory.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'


# =========================================================
# Modular Config Files
# =========================================================


# Aliases
source "$ZDOTDIR/aliases.zsh"

# Custom keybindings
source "$ZDOTDIR/bindings.zsh"

# Plugins and plugin manager
source "$ZDOTDIR/plugins.zsh"

# fzf configuration
source "$ZDOTDIR/fzf.zsh"

# Prompt/theme
source "$ZDOTDIR/prompt.zsh"

# Custom functions
source "$ZDOTDIR/functions.zsh"


# =========================================================
# Tool integrations
# =========================================================


# Cache eval output for fzf/zoxide/atuin — avoids forking a subprocess on every
# shell start. Cache is invalidated when the binary itself changes.
_cache_eval() {
  local cmd="$1" cache="${XDG_CACHE_HOME}/zsh/eval-${1:t}"
  if [[ ! -f "$cache" || "$cache" -ot "${commands[$cmd]}" ]]; then
    mkdir -p "${cache:h}"
    "$cmd" "${@:2}" > "$cache"
  fi
  source "$cache"
}

# disable ctrl-r default binding, because atuin will take over and show history search in an fzf popup instead.
local _fzf_cache="${XDG_CACHE_HOME}/zsh/eval-fzf"
if [[ ! -f "$_fzf_cache" || "$_fzf_cache" -ot "${commands[fzf]}" ]]; then
  mkdir -p "${_fzf_cache:h}"
  FZF_CTRL_R_COMMAND= fzf --zsh > "$_fzf_cache"
fi
FZF_CTRL_R_COMMAND= source "$_fzf_cache"
unset _fzf_cache

_cache_eval zoxide init zsh --cmd cd
_cache_eval atuin init zsh
unset -f _cache_eval

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"


# =========================================================
# Local overrides
# =========================================================


source_if_exists ~/.config/zsh/private.zsh
source_if_exists ~/.config/zsh/work.zsh

# Uncomment to print profiler output:
# zprof
