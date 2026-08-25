#!/usr/bin/env bash
set -euo pipefail
r=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
e=${XDG_CONFIG_HOME:-$HOME/.config}/environment.d
mkdir -p "$e"
command -v systemctl >/dev/null || exit 0

if systemctl --user cat ssh-agent.socket &>/dev/null; then
  systemctl --user enable --now ssh-agent.socket
elif systemctl --user cat ssh-agent.service &>/dev/null; then
  systemctl --user enable --now ssh-agent.service
else
  echo "install-ssh-agent: no user unit" >&2; exit 0
fi

listen=$(systemctl --user cat ssh-agent.socket 2>/dev/null | awk -F= '/^ListenStream=/ {print $2; exit}') || true
case ${listen:-} in
  %t/*) sock=$r/${listen#%t/} ;;
  /*) sock=$listen ;;
  *) sock= ;;
esac
[[ -n ${sock:-} && -S $sock ]] || {
  for sock in "$r/ssh-agent.socket" "$r/openssh_agent"; do [[ -S $sock ]] && break; sock=; done
}
[[ -n ${sock:-} ]] || { echo "install-ssh-agent: no socket path" >&2; exit 0; }

rel=${sock#"$r/"}
if [[ $rel == "$sock" ]]; then
  printf 'SSH_AUTH_SOCK=%s\n' "$sock" >"$e/ssh-agent.conf"
  echo "install-ssh-agent: SSH_AUTH_SOCK=$sock"
else
  printf 'SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/%s\n' "$rel" >"$e/ssh-agent.conf"
  echo "install-ssh-agent: SSH_AUTH_SOCK=\$XDG_RUNTIME_DIR/$rel"
fi
systemctl --user set-environment "SSH_AUTH_SOCK=$sock" 2>/dev/null || true
