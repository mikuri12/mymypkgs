#!/bin/bash
# harfbuzz 11.3.1 — meson. ICU off (no lo usamos), freetype/cairo/glib on.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D icu=disabled -D glib=enabled -D freetype=enabled -D cairo=enabled \
  -D gobject=enabled -D tests=disabled -D docs=disabled -D benchmark=disabled \
  -D introspection=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
