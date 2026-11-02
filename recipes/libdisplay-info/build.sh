#!/bin/bash
# libdisplay-info 0.4.0 — meson SIN meson_options propias (verificado contra
# meson.build del tarball 0.4.0: solo default_options; hwdata es dep native
# opcional required:false con fallback a /usr/share/hwdata/pnp.ids).
# OJO: pasar -D tests=... da 'Unknown options' (run 41227384991).
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
