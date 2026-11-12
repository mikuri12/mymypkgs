#!/bin/bash
# fastfetch 2.69.0 — cmake. Sin X11: -DENABLE_X11=OFF y derivados X off.
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DENABLE_X11=OFF -DENABLE_XCB=OFF -DENABLE_XCB_RANDR=OFF -DENABLE_XRANDR=OFF \
  -DENABLE_VDPAU=OFF -DENABLE_VAX11=OFF -DENABLE_VULKAN=OFF
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
