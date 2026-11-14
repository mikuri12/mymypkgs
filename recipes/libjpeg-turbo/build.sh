#!/bin/bash
# libjpeg-turbo 3.2.1 — cmake. SIN SIMD (no hay nasm): -DWITH_SIMD=0.
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DWITH_SIMD=0 -DENABLE_SHARED=ON
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
