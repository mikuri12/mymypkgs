#!/bin/bash
# libsecret 0.21.7 — meson. Sin vala/introspección/docs.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D introspection=disabled -D vala=disabled -D gtk_doc=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
