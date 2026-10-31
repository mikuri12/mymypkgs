#!/bin/bash
# md4c 0.5.2 — CMake.
set -euo pipefail
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DMD4C_BUILD_TESTS=OFF ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
