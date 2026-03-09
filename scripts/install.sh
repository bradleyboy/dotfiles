#!/usr/bin/env bash
set -euxo pipefail

UNAME=$(uname | tr "[:upper:]" "[:lower:]")

echo "Making sure pure prompt is installed"
mkdir -p "$HOME/.zsh"
[ ! -d "$HOME/.zsh/pure" ] && git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

if [ "$UNAME" == "linux" ]; then
  sudo apt update
  sudo apt-get -y install tmux highlight fd-find ripgrep

  [ ! -d "$HOME/.fzf" ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

  # symlink fd-find to fd so telescope works
  mkdir -p $HOME/.local/bin
  ln -s $(which fdfind) $HOME/.local/bin/fd

  echo "Download tmux plugin manager"
  [ ! -d "$HOME/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  # Set up npm global directory in user's home to avoid permission issues
  mkdir -p ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  # For typescript-tools
  npm install -g typescript

  echo "Installing neovim..."
  mkdir -p "$HOME/.local/bin"
  ARCH=$(uname -m)
  if [ "$ARCH" == "aarch64" ] || [ "$ARCH" == "arm64" ]; then
    NVIM_ARCH="arm64"
  else
    NVIM_ARCH="x86_64"
  fi
  curl -sL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${NVIM_ARCH}.appimage" -o "$HOME/.local/bin/nvim"
  chmod +x "$HOME/.local/bin/nvim"
else
  brew install tmux
  brew install fd
  brew install z
  brew install neovim
  brew install highlight
  brew install ripgrep
  brew install ghostty
fi
