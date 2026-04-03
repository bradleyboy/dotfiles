#!/usr/bin/env bash
set -euxo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
  sudo chsh "$(id -un)" --shell /usr/bin/zsh
fi

echo "Pre-installing zsh plugins"
zsh -ic 'exit' 2>/dev/null || true
