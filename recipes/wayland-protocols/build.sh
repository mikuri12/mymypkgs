#!/bin/bash
# wayland-protocols 1.49 — BLFS 12.4 (meson, solo datos/headers).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
