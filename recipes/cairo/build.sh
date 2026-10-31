#!/bin/bash
# cairo 1.18.4 — meson (BLFS 12.4). Sin X11 (wayland puro): xlib/xcb off.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D xlib=disabled -D xlib-xcb=disabled -D xcb=disabled \
  -D tests=disabled -D gtk_doc=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
