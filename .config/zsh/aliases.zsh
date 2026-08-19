# =========================================================
# Aliases
# =========================================================

# Better ls
alias ls='eza --icons=auto'

# Detailed listing
alias ll='eza -lh --icons=auto --git'

# Detailed listing including hidden files
alias la='eza -lah --icons=auto --git'

# Tree view
alias tree='eza --tree --icons=auto'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

alias terraform="tofu"
alias tf="tofu"

# =========================================================
# Core utilities
# =========================================================

alias reload="source ~/.config/zsh/.zshrc"
# alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias c="clear"

# =========================================================
# Navigation
# =========================================================

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -- -='cd -'

# =========================================================
# Git
# =========================================================

alias gst='git status'
alias gsw='git switch'
alias gco='git checkout'
alias ga='git add'
alias gaa='git add --all'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

# magento
alias mci='cd magento && composer install && cd ..'
alias mcu='cd magento && composer update && cd ..'
