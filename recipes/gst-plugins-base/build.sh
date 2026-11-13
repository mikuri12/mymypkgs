#!/bin/bash
# gst-plugins-base 1.26.11 — meson, shared-only, mínimo para Wayland/audio.
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dtests=disabled -Dexamples=disabled -Ddoc=disabled -Dintrospection=disabled \
  -Dnls=disabled -Dwrap_mode=nodownload \
  -Dgl=disabled -Dpango=disabled -Dalsa=enabled -Dcdparanoia=disabled \
  -Dogg=enabled -Dvorbis=enabled -Dtheora=disabled -Dopus=enabled -Dtremor=disabled
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
