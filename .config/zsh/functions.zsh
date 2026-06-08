# =========================================================
# Functions
# =========================================================

source_if_exists() {
  [[ -r $1 ]] && source "$1"
}

# use tldr and if it failes, use man as fallback
man() {
  tldr "$@" 2>/dev/null || command man "$@";
}

# Delete local branches already merged into main/master/develop
git-clean-merged() {
  git fetch --prune origin
  git branch --merged | grep -Ev '^\*|main|master|develop' | xargs git branch --delete
}
alias gmclean='git-clean-merged'

# Update git and clean merged branches
git-sync-clean() {
    git switch $(git remote show origin | grep "HEAD branch" | sed 's/.*: //')
    git pull
    git-clean-merged
}
alias gsync='git-sync-clean'

# opens an interactive directory picker with fzf
z() {
  if [[ $# -eq 0 ]]; then
    cd "$(zoxide query -ls | fzf --preview 'eza -1 {}' --height 40% | awk '{print $2}')"
  else
    zoxide query "$@" | read dir && cd "$dir"
  fi
}