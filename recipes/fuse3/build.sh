#!/bin/bash
# fuse3 (libfuse) 3.18.3 — meson.
# Opciones VERIFICADAS contra meson_options.txt de 3.18.3:
#   disable-mtab/useroot/utils/examples/tests/enable-io-uring/... = boolean
#   udevrulesdir/initscriptdir = string
# OJO: NO existe la opción 'docs' (abortaría con "Unknown options").
# useroot=true: instala fusermount3 setuid root, necesario para que
# xdg-desktop-portal monte los portales FUSE (lo exige el propio upstream).
# initscriptdir vacío: nada de scripts SysV (el PLAN usa runit).
# utils=true: fusermount3/fusermount son IMPRESCINDIBLES (no es solo la lib).
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D utils=true \
  -D examples=false \
  -D useroot=true \
  -D tests=false \
  -D enable-io-uring=false \
  -D initscriptdir= \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
