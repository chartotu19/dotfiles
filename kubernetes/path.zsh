# Google Cloud SDK path (for manual installation)
if [ -d "$HOME/.local/google-cloud-sdk" ]; then
  export PATH="$HOME/.local/google-cloud-sdk/bin:$PATH"
fi

# kubectl autocompletion
if command -v kubectl > /dev/null 2>&1; then
  source <(kubectl completion zsh) 2>/dev/null
fi
