# Register SSH keys with the macOS agent and keychain
# Code written by ChatGPT 

SSH_KEYS=(
  "$HOME/.ssh/id_ed25519_github"
  "$HOME/.ssh/id_ed25519_dulinlab_gitlab"
)

for key in "${SSH_KEYS[@]}"; do
    if [ -f "$key" ]; then
        if ! ssh-add -l | grep -q "$(basename "$key")"; then
            ssh-add --apple-use-keychain "$key" > /dev/null 2>&1
        fi
    fi
done
