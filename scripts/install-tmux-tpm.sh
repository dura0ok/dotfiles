#!/usr/bin/env bash
set -euo pipefail

TPM_DIR="${HOME}/.tmux/plugins/tpm"
PLUG_DIR="${HOME}/.config/tmux/plugins"

mkdir -p "${HOME}/.tmux/plugins" "${PLUG_DIR}"

if [[ ! -d "${TPM_DIR}/.git" ]]; then
  GIT_TERMINAL_PROMPT=0 git clone https://github.com/tmux-plugins/tpm "${TPM_DIR}"
fi

clone_plugin_github() {
  local slug="$1"
  local dir="${slug##*/}"
  dir="${dir%.git}"
  local branch="${2:-}"
  local url="https://github.com/${slug}.git"
  local dest="${PLUG_DIR}/${dir}"
  if [[ -d "${dest}/.git" ]]; then
    echo "tmux: plugin ${slug} already present at ${dest}"
    return 0
  fi
  echo "tmux: cloning ${slug} -> ${dest}"
  if [[ -n "${branch}" ]]; then
    GIT_TERMINAL_PROMPT=0 git clone --branch "${branch}" --single-branch --depth 1 "${url}" "${dest}"
  else
    GIT_TERMINAL_PROMPT=0 git clone --depth 1 "${url}" "${dest}"
  fi
}

clone_plugin_github "catppuccin/tmux" "v2.3.0"
clone_plugin_github "tmux-plugins/tmux-resurrect"

resolve_tmux_conf() {
  local xdg="${XDG_CONFIG_HOME:-${HOME}/.config}/tmux/tmux.conf"
  if [[ -f "${xdg}" ]]; then
    echo "${xdg}"
    return 0
  fi
  if [[ -f "${HOME}/.tmux.conf" ]]; then
    echo "${HOME}/.tmux.conf"
    return 0
  fi
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local repo_conf="${script_dir}/../tmux/tmux.conf"
  if [[ -f "${repo_conf}" ]]; then
    echo "${repo_conf}"
    return 0
  fi
  echo ""
}

CONF="$(resolve_tmux_conf)"
if [[ -z "${CONF}" ]]; then
  echo "tmux: no tmux.conf found — run ./install to link dotfiles."
  exit 0
fi

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux: tmux not installed; TPM cloned, plugins downloaded; run tmux after installing tmux."
  exit 0
fi

tmux start-server 2>/dev/null || true
if ! tmux source-file "${CONF}"; then
  echo "tmux: warning: source-file ${CONF} failed (see errors above). Trying TPM install_plugins anyway."
fi

if [[ -x "${TPM_DIR}/scripts/install_plugins.sh" ]]; then
  "${TPM_DIR}/scripts/install_plugins.sh" || echo "tmux: install_plugins.sh failed — plugins were cloned directly above; press Ctrl+b then I in tmux to retry." >&2
fi

echo "tmux: reload with: tmux source-file ${CONF}"
echo "tmux: in tmux, Ctrl+b then I installs/updates plugins; Ctrl+b then U updates."
