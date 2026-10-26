#!/bin/bash
# libxkbcommon 1.11.0 — BLFS 12.4 (meson).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D enable-docs=false \
  -D xkb-config-root=/usr/share/X11/xkb \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
