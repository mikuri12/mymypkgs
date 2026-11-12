#!/bin/bash
# wlsunset 0.4.0 — meson. wayland-scanner viene del paquete wayland.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
