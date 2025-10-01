# ---- Starship terminal prompt ---- 
eval "$(starship init zsh)"

# --- Add SSH keys to key-chain --- 
source ~/dotfiles/scripts/ssh_key_registration.sh

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


# Use bat / eza to show a nice preview of either the directory tree or the file contents when using fzf 
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500{}"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments ($@) to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always --icons=always {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always --line-range :500 {}' "$@" ;;
  esac
}


# Use Catpuccin theme when in fzf (see https://github.com/catppuccin/fzf/tree/main)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"


# ---- bat (a better 'cat'. Display content to terminal with syntax highlighting) --- 
export BAT_THEME="Catppuccin Mocha"

# --- eza (a nicer 'ls') --- 
alias ls="eza --color=always --icons=always --long --git --no-permissions --no-time --no-user --no-filesize"

# --- zoxide (a nicer 'cd' to navigate into directories.) --- 
eval "$(zoxide init zsh)"
alias cd="z"

# --- UV (Python package manager) --- 
eval "$(uv generate-shell-completion zsh)" 

# --- Microsoft Office Suite --- 
# 📄 Open a Word document
word() {
  open -a "Microsoft Word" "$@"
}

# 📊 Open an Excel spreadsheet
excel() {
  open -a "Microsoft Excel" "$@"
}

# 📽️ Open a PowerPoint presentation
powerpoint() {
  open -a "Microsoft PowerPoint" "$@"
}
