#!/usr/bin/env bash

SCRIPT_DIR=$( dirname $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) )

ln -sf "$SCRIPT_DIR/.zshrc" ~/.zshrc
ln -sf "$SCRIPT_DIR/.tmux.conf" ~/.tmux.conf
ln -sf "$SCRIPT_DIR/nvim" ~/.config/nvim
ln -sf "$SCRIPT_DIR/gitconfig.aliases" ~/.gitconfig.aliases

if [[ "$(uname)" == "Darwin" ]]; then
  ln -sf "$SCRIPT_DIR/alacritty" ~/.config/alacritty
  ln -sf "$SCRIPT_DIR/ghostty" ~/.config/ghostty
fi
