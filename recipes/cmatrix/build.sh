#!/bin/bash
# cmatrix v2.0 — cmake (build_tools lo instala en el chroot). ncurses en la base.
set -euo pipefail
# CMake 4.x eliminó compatibilidad con cmake_minimum_required < 3.5 (cmatrix v2.0
# declara 2.8): este flag restaura el mínimo a 3.5 sin tocar el código.
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
