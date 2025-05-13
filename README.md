# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install git
brew install stow # https://www.gnu.org/software/stow/manual/stow.html
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
git clone git@github.com/marvincaspar/dotfiles.git
cd dotfiles
git submodule init
git submodule update --recursive --remote
```

Install brew packages

```
brew bundle --file=brew/Brewfile
brew cask bundle --file=brew/Brewfile.cask
```

Install or configure tools

```
./install-tools.sh
./symlink-scripts.sh
```

then use GNU stow to create symlinks

```
stow .
```

## Color scheme

I try to use the same color scheme as tools. Currently I prefer [catppuccin/mocha](https://github.com/catppuccin/).
