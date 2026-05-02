#!/usr/bin/env bash
# https://code.visualstudio.com/docs/setup/linux
set -euo pipefail
[[ -n ${DOTFILES_SKIP_APPS:-} ]] && exit 0
command -v code >/dev/null 2>&1 && exit 0

if command -v dnf >/dev/null 2>&1; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  if [[ ! -f /etc/yum.repos.d/vscode.repo ]]; then
    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
  fi
  sudo dnf install -y code
elif command -v apt-get >/dev/null 2>&1; then
  sudo install -d -m0755 /etc/apt/keyrings
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  sudo apt-get update -qq
  sudo apt-get install -y code
else
  echo "install-vscode: unsupported OS (dnf/apt only)" >&2
  exit 1
fi
