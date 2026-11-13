#!/bin/bash
# gstreamer 1.26.11 core — meson, shared-only, sin ejemplos/tests/doc.
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dtests=disabled -Dexamples=disabled -Dbenchmarks=disabled -Ddoc=disabled \
  -Dintrospection=disabled -Dnls=disabled -Dlibunwind=disabled -Dlibdw=disabled \
  -Ddbghelp=disabled -Dgst_debug=true \
  -Dwrap_mode=nodownload
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
