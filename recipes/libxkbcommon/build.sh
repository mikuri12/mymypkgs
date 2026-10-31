#!/bin/bash
# libxkbcommon 1.11.0 — BLFS 12.4 (meson).
set -euo pipefail
mkdir build && cd build
# PLAN: Wayland puro — sin X11 ni xwayland en libxkbcommon (xcb no está
# en la base y no se necesita). xkeyboard-config TBM (tomorrow) para maps.
meson setup --prefix=/usr --buildtype=release \
  -D enable-docs=false -D enable-x11=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
