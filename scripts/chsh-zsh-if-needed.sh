#!/usr/bin/env bash
set -euo pipefail
Z="$(command -v zsh)"
[[ -n "$Z" && -x "$Z" ]] || { echo "chsh: zsh not in PATH" >&2; exit 1; }
C="$(readlink -f "${SHELL}" 2>/dev/null || echo "$SHELL")"
T="$(readlink -f "$Z")"
[[ $C == "$T" ]] && exit 0
grep -qxF "$Z" /etc/shells 2>/dev/null || echo "chsh: $Z not in /etc/shells" >&2
exec chsh -s "$Z"
