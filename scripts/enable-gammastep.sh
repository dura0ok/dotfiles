#!/usr/bin/env bash
set -euo pipefail
command -v gammastep >/dev/null 2>&1 || exit 0
command -v systemctl >/dev/null 2>&1 || exit 0

systemctl --user disable --now redshift.service redshift-gtk.service 2>/dev/null || true

session="${XDG_SESSION_TYPE:-}"
if [[ -z "$session" && -n "${WAYLAND_DISPLAY:-}" ]]; then
  session=wayland
elif [[ -z "$session" && -n "${DISPLAY:-}" ]]; then
  session=x11
fi

case "$session" in
  wayland) method=wayland ;;
  x11) method=randr ;;
  *) method=randr ;;
esac

dropin_dir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user/gammastep.service.d"
mkdir -p "$dropin_dir"
cat >"$dropin_dir/method.conf" <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/gammastep -m ${method}
EOF

systemctl --user daemon-reload
systemctl --user enable --now gammastep.service
systemctl --user restart gammastep.service
