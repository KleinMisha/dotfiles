# ---- Starship terminal prompt ---- 
eval "$(starship init zsh)"

# --- Add SSH keys to key-chain --- 
# Load GitHub SSH key into agent if not already loaded
if ! ssh-add -l | grep -q "id_ed25519_github"; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github > /dev/null 2>&1
fi

# --- zsh-autosuggestions --- 
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# --- zsh-syntax-highlighting --- 
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# --- zsh-completions --- 
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# -----------  FuzzyFinder (fzf) (https://github.com/junegunn/fzf#setting-up-shell-integration) --------- 
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# fd (https://github.com/sharkdp/fd) 
# Tell fzf to use `fd` instead of `find` (A nicer version that shows colors, etc.) 
export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git" 
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# fzf-git keybindings  (clone the repo manually and activate the file. instructions are found here: https://github.com/junegunn/fzf-git.sh)
# Clone if not already present (will clone into the path defined in the next line)
FZF_GIT_SH="$HOME/fzf-git.sh"
if [ ! -d "$FZF_GIT_SH" ]; then
    git clone https://github.com/junegunn/fzf-git.sh.git "$FZF_GIT_SH"
fi

# Source the script
source $FZF_GIT_SH/fzf-git.sh

