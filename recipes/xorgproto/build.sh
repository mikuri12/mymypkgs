#!/bin/bash
# xorgproto 2025.1 — meson (headers + xproto.pc).
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr ..
ninja
DESTDIR="$DESTDIR" ninja install
