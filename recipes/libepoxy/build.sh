#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dx11=false -Dglx=no -Degl=yes -Dtests=false "$d"
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
