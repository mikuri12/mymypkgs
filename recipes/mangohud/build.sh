#!/bin/bash
# MangoHud v0.8.4 — meson. Sin xnvctrl; wayland soportado por defecto.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -Dwith_xnvctrl=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
