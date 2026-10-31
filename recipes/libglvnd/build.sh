#!/bin/bash
# libglvnd 1.7.0 — meson (BLFS 12.4). Verificado contra meson_options.txt
# del tarball GitHub v1.7.0 (sha 073e7292…): NO existe option tests
# (12 opciones: asm/x11=feature, egl/glx/hgl/gles1/gles2/tls/
# dispatch-tls/headers=boolean, entrypoint-patching=feature). Pasar
# -D tests=… rompe meson setup con Unknown options (run 41236509817).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D x11=disabled -D glx=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
