#!/bin/bash
# wlroots 0.20.0 — meson. Sin Xwayland (xwayland-satellite aparte), sin ejemplos.
# Opciones REALES de wlroots 0.20 (meson.options): xcb-errors, xwayland,
# examples(boolean), icon_directory, renderers(auto/gles2/vulkan),
# backends(auto/drm/libinput/x11), allocators(auto/gbm/udmabuf), session,
# color-management, libliftoff. NO existen 'tests', 'allocator', 'pixman' ni
# el backend 'wayland'.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D xwayland=disabled \
  -D examples=false \
  -D backends=drm,libinput \
  -D renderers=gles2 \
  -D allocators=gbm \
  -D session=enabled \
  -D color-management=disabled \
  -D libliftoff=disabled \
  -D xcb-errors=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
