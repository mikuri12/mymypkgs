#!/bin/bash
# highway 1.3.0 — CMake. Solo libhwy, sin tests/ejemplos.
set -euo pipefail
rm -rf build && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF -DHWY_ENABLE_TESTS=OFF -DHWY_ENABLE_EXAMPLES=OFF \
  ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
