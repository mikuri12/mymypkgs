#!/bin/bash
# cmatrix v2.0 — cmake (build_tools lo instala en el chroot). ncurses en la base.
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
