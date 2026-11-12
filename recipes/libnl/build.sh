#!/bin/bash
# libnl 3.11.0 — cmake (build_tools lo instala en el chroot).
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
