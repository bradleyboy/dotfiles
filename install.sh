#!/usr/bin/env bash

SCRIPT_DIR=$( dirname $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) )

"$SCRIPT_DIR/dotfiles/scripts/install.sh"
"$SCRIPT_DIR/dotfiles/scripts/links.sh"
"$SCRIPT_DIR/dotfiles/scripts/setup.sh"
