#!/usr/bin/env bash
set -euxo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
  sudo chsh "$(id -un)" --shell /usr/bin/zsh
fi
