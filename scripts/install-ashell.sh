#!/usr/bin/env bash
# Install ashell ≥0.9.0 (named workspace labels need content-sized buttons).
set -euo pipefail

ASHELL_MIN=0.9.0
ASHELL_RPM_URL="https://github.com/MalpenZibo/ashell/releases/download/${ASHELL_MIN}/ashell-x86_64-unknown-linux-gnu.rpm"

if [[ ${DOTFILES_SKIP_APPS:-0} == 1 ]]; then
  echo "skip: ashell (DOTFILES_SKIP_APPS=1)"
  exit 0
fi

version_ge() {
  # true if $1 >= $2 (simple X.Y.Z)
  printf '%s\n' "$1" "$2" | sort -V | head -n1 | grep -qx "$2"
}

installed_ver() {
  ashell --version 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || true
}

need_install=1
if command -v ashell >/dev/null 2>&1; then
  ver=$(installed_ver)
  if [[ -n $ver ]] && version_ge "$ver" "$ASHELL_MIN"; then
    echo "ok: ashell $ver"
    need_install=0
  else
    echo "upgrade: ashell ${ver:-unknown} → ${ASHELL_MIN}"
  fi
fi

((need_install)) || exit 0

if ! command -v dnf >/dev/null 2>&1; then
  echo "skip: ashell (non-dnf; install ${ASHELL_MIN}+ from https://malpenzibo.github.io/ashell/docs/installation)"
  exit 0
fi

tmp=$(mktemp -t ashell-XXXXXX.rpm)
trap 'rm -f "$tmp"' EXIT
echo "install: ashell ${ASHELL_MIN} (official rpm)"
curl -fsSL -o "$tmp" "$ASHELL_RPM_URL"
sudo dnf -y install "$tmp"
ashell --version
