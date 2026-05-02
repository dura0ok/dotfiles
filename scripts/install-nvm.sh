#!/usr/bin/env bash
set -euo pipefail
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
V="${NVM_VERSION:-v0.40.1}"
[[ -s $NVM_DIR/nvm.sh ]] || curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$V/install.sh" | bash
# shellcheck disable=SC1090
source "$NVM_DIR/nvm.sh"
nvm install node
