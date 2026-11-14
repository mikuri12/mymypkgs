#!/bin/bash
# libass 0.17.5 — meson (meson/ninja ya en la base). deps: freetype, harfbuzz,
# fribidi, fontconfig (auto).
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
