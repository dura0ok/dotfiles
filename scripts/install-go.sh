#!/usr/bin/env bash
set -euo pipefail
if command -v wget >/dev/null 2>&1; then
  wget -qO- --timeout=60 'https://git.io/go-installer.sh' | bash
else
  curl -fsSL --connect-timeout 10 --max-time 60 'https://raw.githubusercontent.com/kerolloz/go-installer/master/go.sh' | bash
fi
