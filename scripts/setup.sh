#!/usr/bin/env bash
set -euxo pipefail

sudo chsh "$(id -un)" --shell "/usr/bin/zsh"
