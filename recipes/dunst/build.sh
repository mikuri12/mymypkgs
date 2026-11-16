#!/bin/bash
# dunst 1.12.2 — desde 1.12.x el tarball upstream trae Makefile plano (sin meson.build).
# Rootfs Wayland-only: WAYLAND=1 X11=0 (asi no exige xscrnsaver/xinerama/xext/xrandr).
set -euo pipefail
POD2MAN_BIN="pod2man"
command -v pod2man >/dev/null 2>&1 || POD2MAN_BIN="true"
ARGS="PREFIX=/usr WAYLAND=1 X11=0 SYSTEMD=0 COMPLETIONS=0 DUNSTIFY=1 POD2MAN=$POD2MAN_BIN"
make -j"$(nproc)" $ARGS
make DESTDIR="$DESTDIR" $ARGS install
