#!/usr/bin/env bash
set -euxo pipefail

UNAME=$(uname | tr "[:upper:]" "[:lower:]")

echo "Making sure pure prompt is installed"
mkdir -p "$HOME/.zsh"
[ ! -d "$HOME/.zsh/pure" ] && git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

if [ "$UNAME" == "linux" ]; then
  sudo apt update
  sudo apt-get -y install tmux highlight

  [ ! -d "$HOME/.fzf" ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

  echo "Download tmux plugin manager"
  [ ! -d "$HOME/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  echo "Installing neovim..."
  mkdir -p "$HOME/.local/bin"
  curl -sL https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage -o "$HOME/.local/bin/nvim"
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
