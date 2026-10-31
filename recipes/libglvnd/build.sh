#!/bin/bash
# libglvnd 1.7.0 — meson (BLFS 12.4). Sin Xorg libs (wayland puro + EGL).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D tests=false -D x11=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
