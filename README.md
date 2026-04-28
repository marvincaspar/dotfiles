# My dotfiles

This directory contains the dotfiles for my system

## Requirements

All required tools are installed within `make setup` command.

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
git clone git@github.com/marvincaspar/dotfiles.git ~/dotfiles
cd dotfiles
make setup
```

> **_NOTE:_** `.agents` dir is copied to your home directory and not symlinked, because the ai agent within a sandbox can't follow the symlink

## Color scheme

I try to use the same color scheme as tools. Currently I prefer [catppuccin/mocha](https://github.com/catppuccin/).
