# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

```
brew install git
brew install stow # https://www.gnu.org/software/stow/manual/stow.html
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
git clone git@github.com/marvincaspar/dotfiles.git
cd dotfiles
```

Install brew packages

```
brew bundle --file=scripts/Brewfile
brew cask bundle --file=scripts/Brewfile.cask
```

then use GNU stow to create symlinks

```
stow .
```