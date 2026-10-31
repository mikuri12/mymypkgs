#!/bin/bash
# libdisplay-info 0.3.0 — meson SIN meson_options propias (verificado contra
# meson.build del tarball 0.3.0: solo default_options; hwdata es dep native
# opcional required:false). Sin -D.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
