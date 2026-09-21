#!/usr/bin/env bash
set -euo pipefail
command -v redshift >/dev/null 2>&1 || exit 0
command -v systemctl >/dev/null 2>&1 || exit 0
systemctl --user enable --now redshift.service
