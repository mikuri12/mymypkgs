#!/bin/bash
# fribidi 1.0.16 — meson; instala libfribidi + fribidi.pc en /usr.
set -euo pipefail
rm -rf build && rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D docs=false -D bin=false -D tests=false ..
ninja
DESTDIR="$DESTDIR" ninja install
