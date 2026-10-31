#!/bin/bash
# wlroots 0.20.0 — meson. Sin Xwayland (xwayland-satellite aparte), sin ejemplos.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D xwayland=disabled -D examples=false \
  -D tests=false -D backends=drm,libinput,wayland \
  -D renderers=gles2,pixman \
  -D allocator=gbm \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
