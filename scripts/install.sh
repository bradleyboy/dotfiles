#!/usr/bin/env bash
set -euxo pipefail

UNAME=$(uname | tr "[:upper:]" "[:lower:]")

echo "Making sure pure prompt is installed"
mkdir -p "$HOME/.zsh"
[ ! -d "$HOME/.zsh/pure" ] && git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

echo "Syncing claude-skills"
mkdir -p "$HOME/.claude"
SKILLS_DIR="$HOME/.claude/skills"
SKILLS_URL="https://github.com/bradleyboy/claude-skills.git"
if [ ! -d "$SKILLS_DIR" ]; then
  git clone "$SKILLS_URL" "$SKILLS_DIR"
else
  STASHED=0
  if ! git -C "$SKILLS_DIR" diff --quiet || ! git -C "$SKILLS_DIR" diff --cached --quiet; then
    git -C "$SKILLS_DIR" stash push -u -m "dotfiles-install autostash" && STASHED=1
  fi
  git -C "$SKILLS_DIR" pull --ff-only || echo "WARNING: claude-skills pull failed — leaving as-is"
  if [ "$STASHED" -eq 1 ]; then
    git -C "$SKILLS_DIR" stash pop || echo "WARNING: claude-skills stash pop had conflicts — resolve manually in $SKILLS_DIR"
  fi
fi

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
  # For typescript-tools (non-fatal — npm may not be available in all envs)
  if ! npm install -g typescript; then
    echo "WARNING: npm install -g typescript failed — skipping (typescript-tools may not work)"
  fi

  echo "Installing neovim..."
  mkdir -p "$HOME/.local/bin"
  ARCH=$(uname -m)
  if [ "$ARCH" == "aarch64" ] || [ "$ARCH" == "arm64" ]; then
    NVIM_ARCH="arm64"
    TS_ARCH="arm64"
  else
    NVIM_ARCH="x86_64"
    TS_ARCH="x64"
  fi
  curl -sL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${NVIM_ARCH}.appimage" -o "$HOME/.local/bin/nvim"
  chmod +x "$HOME/.local/bin/nvim"

  echo "Installing tree-sitter-cli..."
  curl -sL "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.8/tree-sitter-linux-${TS_ARCH}.gz" | gunzip > "$HOME/.local/bin/tree-sitter"
  chmod +x "$HOME/.local/bin/tree-sitter"
else
  brew install tmux
  brew install fd
  brew install z
  brew install neovim
  brew install tree-sitter-cli
  brew install highlight
  brew install ripgrep
  brew install ghostty
fi
