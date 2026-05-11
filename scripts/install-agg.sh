#!/usr/bin/env bash
set -euo pipefail
command -v cargo >/dev/null 2>&1 || exit 0
if command -v agg >/dev/null 2>&1; then
  exit 0
fi
CARGO_INSTALL_ROOT="${HOME}/.local" cargo install --git https://github.com/asciinema/agg
