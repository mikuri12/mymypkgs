#!/bin/bash
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release -Dxkb-base=/usr/share/X11/xkb
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
