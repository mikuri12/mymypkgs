#!/bin/bash
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dintrospection=disabled -Ddocs=false -Dtests=false
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
