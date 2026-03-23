#!/bin/bash

# stow.sh — run from anywhere
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

stow --target="$HOME" --dir="$DOTFILES_DIR" "$@"
