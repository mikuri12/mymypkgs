#!/bin/bash
# cairo 1.18.4 — meson (BLFS 12.4). con X11 (xlib/xcb on) para gtk3-x11/thunar.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D xlib=enabled -D xlib-xcb=enabled -D xcb=enabled \
  -D tests=disabled -D gtk_doc=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
