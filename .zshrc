# zmodload zsh/zprof


source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme


export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""


plugins=(git)
source_if_exists $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship is a cross-shell prompt, can be used instead of p10k
# Remove all p10k parts if you want to use starship
# eval "$(starship init zsh)"
# export STARSHIP_CONFIG=~/.config/starship/starship.toml

source $ZSH/oh-my-zsh.sh


# fzf
source_if_exists ~/.config/zsh/fzf.zsh
bindkey "ç" fzf-cd-widget
# search filed with fd -> automatically excludes files from .gitignore
# export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --ignore-file ~/.fdignore'
alias fzfp="fzf --preview 'bat --color=always {}' --preview-window '~3'"


# git clean up merged branches
gcmb() {
  git fetch --prune origin

  git branch --merged | egrep -v "(^\*|main|master|develop)" | xargs git branch --delete
}


alias cat="bat"
alias ls="eza"
alias la="eza --long --all --group"
alias man="tldr"
alias c="clear"

# SSH issues with kitten https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-or-functional-keys-like-arrow-keys-don-t-work
alias s="kitten ssh"

eval $(thefuck --alias)
eval "$(zoxide init zsh --cmd cd)"


export PATH=$HOME/bin:/usr/local/bin:$(go env GOPATH)/bin:$HOME/dotfiles/scripts:$PATH


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/powerlevel10k/p10k.zsh ]] || source ~/.config/powerlevel10k/p10k.zsh

# zprof