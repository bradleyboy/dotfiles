#!/usr/bin/env bash
set -euxo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
  sudo chsh -s /bin/zsh "$(id -un)"
else
  sudo chsh "$(id -un)" --shell /usr/bin/zsh
fi
