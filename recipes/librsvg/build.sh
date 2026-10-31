#!/bin/bash
# librsvg 2.61.1 — meson + cargo (el loader de SVG es Rust). Chroot sin red:
# vendor offline inyectado por el workflow (librsvg-vendor.tar.gz).
set -euo pipefail
export CARGO_INCREMENTAL=0
export CARGO_NET_OFFLINE=true
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D introspection=disabled -D vala=disabled -D docs=disabled \
  -D tests=false -D pixbuf=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
