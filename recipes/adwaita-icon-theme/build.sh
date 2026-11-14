#!/bin/bash
# adwaita-icon-theme 47.0 — meson (47 ya no trae autotools), datos-only.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
meson setup build --prefix=/usr --buildtype=release "$d"
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
