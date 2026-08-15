#!/usr/bin/env bash
# Ensure niri desktop runtime files / optional Flatpak helpers.
set -euo pipefail

if [[ ${DOTFILES_SKIP_APPS:-0} == 1 ]]; then
  echo "skip: niri desktop apps (DOTFILES_SKIP_APPS=1)"
  exit 0
fi

mkdir -p "${HOME}/.config/niri" "${HOME}/Pictures/Screenshots" "${HOME}/.local/bin"
touch "${HOME}/.config/niri/workspaces.kdl"

if ! command -v flatpak >/dev/null 2>&1; then
  echo "skip: flatpak not installed (pwvucontrol)"
  exit 0
fi

if ! flatpak info com.saivert.pwvucontrol >/dev/null 2>&1; then
  echo "install: flatpak com.saivert.pwvucontrol"
  flatpak install -y flathub com.saivert.pwvucontrol || true
fi
