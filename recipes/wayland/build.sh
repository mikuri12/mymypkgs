#!/bin/bash
# wayland 1.25.0 — meson. Opciones del meson_options.txt upstream
# (verificadas contra el tarball): documentation/tests/dtd_validation
# son BOOLEANAS aquí (a diferencia de libinput, donde son features).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D documentation=false \
  -D tests=false \
  -D dtd_validation=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
