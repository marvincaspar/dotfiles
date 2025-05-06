#!/bin/sh

echo "Configure fzf keybindings"
$(brew --prefix)/opt/fzf/install --key-bindings --completion --update-rc

# Set the directory we want to store zinit and plugins
ZDOTDIR="${HOME}/.antidote"

# Download Zinit, if it's not there yet
if [ ! -d "$ZDOTDIR" ]; then
   git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR}
fi