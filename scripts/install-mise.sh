set -euo pipefail

if command -v mise >/dev/null 2>&1; then
  echo "mise: already installed ($(command -v mise))"
  mise --version
  exit 0
fi

curl -fsSL https://mise.run | sh
