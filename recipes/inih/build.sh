#!/bin/bash
# inih r62 — meson.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -Ddistro_install=true ..
ninja
DESTDIR="$DESTDIR" ninja install
