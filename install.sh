#!/usr/bin/env bash
set -e

readonly BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTBOT_DIR="dotbot"
readonly DOTBOT_BIN="bin/dotbot"

cd "$BASEDIR"

git submodule sync --quiet --recursive
git submodule update --init --recursive

run_dotbot () {
  local config="$1"
  shift
  "$BASEDIR/$DOTBOT_DIR/$DOTBOT_BIN" \
    -d "$BASEDIR" \
    -c "$config" \
    "$@"
}

for step in "$BASEDIR"/steps/*.yml; do
  run_dotbot "$step" || echo "⚠️  Step failed: $step"
done
