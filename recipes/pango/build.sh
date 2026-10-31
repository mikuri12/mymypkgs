#!/bin/bash
# pango 1.56.4 — meson. Sin X11, introspección off.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D xft=disabled -D introspection=disabled -D gtk_doc=false \
  -D tests=false -D examples=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
