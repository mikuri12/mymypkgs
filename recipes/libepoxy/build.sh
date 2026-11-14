#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dglx=yes -Degl=yes -Dx11=true -Dtests=false "$d"
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
