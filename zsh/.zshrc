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