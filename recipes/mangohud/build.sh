#!/bin/bash
# MangoHud v0.8.4 — meson. Sin X11 ni xnvctrl (no hay libX11/libXNVCtrl en el
# rootfs Wayland); wayland sí. Sin nvml (driver NVIDIA no aplica).
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -Dwith_x11=disabled -Dwith_xnvctrl=disabled -Dwith_nvml=disabled \
  -Dmangoapp=false -Dtests=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
