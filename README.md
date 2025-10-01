# My configurations for my MacOS apps 

Everything to quickly set up a new MacOS machine the way I like it. Ready for software development (+ utility tools for window management, spotify, etc.)

Contains all "hidden `.dotfiles` and other configurations files" for the apps / software packages installed on my MacOS. 
This will help setting up a new machine in the future. 

> I use `GNU stow` to 'map' the contents of this directory to the home directory (as the applications expect them). `stow` will create 'symbolic links' (a pointer to the file in this directory). Editing the original file (the one in this directory) or the one at the linked location results in the same (both will get edited as they are linked together / same pointer / same memory address on your computer after the symbolic link)

## Setting up a new machine 
1. **Clone the dotfiles repository**
	```bash
	git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
	cd ~/dotfiles
	```

2. **Install Homebrew (if not already installed)**
	```bash 
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	```
4. **Install packages from the Brewfile**

   ```bash
	brew bundle --file=~/dotfiles/Brewfile
	```
	The Brewfile includes only explicitly installed formulae and all casks. Dependencies are not included.

1. **Symlink dotfiles with GNU Stow**

	For each package (subdirectory) in your dotfiles repo:
	```bash
	stow <package_name>
	```

	Example:
	```bash
	stow zsh
	stow git
	stow ghostty
	stow bat
	stow ssh
	```

	To symlink all packages at once:
	```bash
	stow */


	To restow after making changes:

	stow -R <package_name>


	To unstow (remove symlinks):

	stow -D <package_name>
	```
1. **Manually symlink the VS Code settings**
   
   ***Note: this step is technically optional as VS Code already syncs my user settings. This step just enables editing the settings file in this centralized location.***
   
   The User settings for VS Code are not stored in the root directory, or some simple deviation from it. Using `stow` would makes things needlessly complicated: 
   ```bash
   ln -s ~/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
   ```

## Installed Software

|name|desc|homepage|formula/cask
|----|----|--------|------------
bat|Clone of cat(1) with syntax highlighting and Git integration|https://github.com/sharkdp/bat|formula
eza|Modern, maintained replacement for ls|https://github.com/eza-community/eza|formula
fd|Simple, fast and user-friendly alternative to find|https://github.com/sharkdp/fd|formula
fzf|Command-line fuzzy finder written in Go|https://github.com/junegunn/fzf|formula
git|Distributed revision control system|https://git-scm.com|formula
git-delta|Syntax-highlighting pager for git and diff output|https://github.com/dandavison/delta|formula
python@3.13|Interpreted, interactive, object-oriented programming language|https://www.python.org/|formula
starship|Cross-shell prompt for astronauts|https://starship.rs/|formula
stow|Organize software neatly under a single directory tree (e.g. /usr/local)|https://www.gnu.org/software/stow/|formula
tlrc|Official tldr client written in Rust|https://tldr.sh/tlrc/|formula
uv|Extremely fast Python package installer and resolver, written in Rust|https://docs.astral.sh/uv/|formula
wget|Internet file retriever|https://www.gnu.org/software/wget/|formula
zoxide|Shell extension to navigate your filesystem faster|https://github.com/ajeetdsouza/zoxide|formula
zsh-autosuggestions|Fish-like fast/unobtrusive autosuggestions for zsh|https://github.com/zsh-users/zsh-autosuggestions|formula
zsh-completions|Additional completion definitions for zsh|https://github.com/zsh-users/zsh-completions|formula
zsh-syntax-highlighting|Fish shell like syntax highlighting for zsh|https://github.com/zsh-users/zsh-syntax-highlighting|formula
Adobe Acrobat Reader|View, print, and comment on PDF documents|https://www.adobe.com/acrobat/pdf-reader.html|cask
FreeMacSoft AppCleaner|Application uninstaller|https://freemacsoft.net/appcleaner/|cask
Hack Nerd Font (Hack)|-|https://github.com/ryanoasis/nerd-fonts|cask
Ghostty|Terminal emulator that uses platform-native UI and GPU acceleration|https://ghostty.org/|cask
Hidden Bar|Utility to hide menu bar items|https://github.com/dwarvesf/hidden/|cask
Maccy|Clipboard manager|https://maccy.app/|cask
Microsoft Auto Update|Provides updates to various Microsoft products|https://docs.microsoft.com/officeupdates/release-history-microsoft-autoupdate|cask
Microsoft Excel|Spreadsheet software|https://www.microsoft.com/en-US/microsoft-365/excel|cask
Microsoft Outlook|Email client|https://www.microsoft.com/en-us/microsoft-365/outlook/outlook-for-business|cask
Microsoft PowerPoint|Presentation software|https://www.microsoft.com/en-US/microsoft-365/powerpoint|cask
Microsoft Word|Word processor|https://www.microsoft.com/en-US/microsoft-365/word|cask
Rectangle|Move and resize windows using keyboard shortcuts or snap areas|https://rectangleapp.com/|cask
Spotify|Music streaming service|https://www.spotify.com/|cask
Microsoft Visual Studio Code|Open-source code editor|https://code.visualstudio.com/|cask

## Add a new brew package? 
This repo contains two scripts that will: 
1. Fetch the description / information and place it in the table above.  
	```bash
	python3.13 scripts/create_table_installed_homebrew_packages.py
	```
2. Create a lean BrewFile with **only the installed packaged, excluding dependencies thereof** (for some reason `homebrew` does not have an option to do this)
	```bash
	python3.13 scripts/create_brew_file.py
	```