# Default target
.PHONY: help
help: ## Show this help message
    @echo "Usage:"
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
        sort | \
        awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Set up the development environment
	@echo "Setting up the development environment..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	brew install git
	brew install stow
	@make install
	@echo "Development environment setup complete."

.PHONY: update
update: ## Update the dotfiles repository
	@echo "Updating dotfiles repository..."
	git pull origin main
	@make install
	@echo "Dotfiles updated successfully."

.PHONY: install
install: ## Install dotfiles using GNU Stow
	@echo "Installing dotfiles..."
	stow .
	brew bundle --file=brew/Brewfile
	brew cask bundle --file=brew/Brewfile.cask
	./symlink-scripts.sh
	./install-tools.sh	
	osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "/Users/'$USER'/dotfiles/wallpaper/20250908.jpg"'
	@echo "Dotfiles installed successfully."