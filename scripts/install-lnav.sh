#!/usr/bin/env bash
set -euo pipefail
[[ $(uname -m) == x86_64 ]] || { echo "install-lnav: skip (need x86_64)" >&2; exit 0; }
R="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
Z=
shopt -s nullglob
for f in "$R/lnav"/lnav-*-linux-musl-x86_64.zip; do Z=$f; break; done
shopt -u nullglob
[[ -n $Z && -f $Z ]] || { echo "install-lnav: no lnav-*-linux-musl-x86_64.zip in $R/lnav" >&2; exit 1; }
T="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles-lnav"
mkdir -p "$HOME/.local/bin" "$T"
rm -rf "$T"/lnav-*
unzip -oq "$Z" -d "$T"
shopt -s nullglob
dirs=( "$T"/lnav-* )
shopt -u nullglob
((${#dirs[@]} == 1)) || { echo "install-lnav: expected exactly one lnav-* directory after unzip" >&2; exit 1; }
ln -sfn "${dirs[0]}/lnav" "$HOME/.local/bin/lnav"
