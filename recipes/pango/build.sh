#!/bin/bash
# pango 1.56.4 — meson. Sin X11, introspección off.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D xft=disabled -D introspection=disabled -D gtk_doc=false \
  -D build-testsuite=false -D build-examples=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
