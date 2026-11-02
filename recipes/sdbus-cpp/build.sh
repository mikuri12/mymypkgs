#!/bin/bash
# sdbus-c++ 2.1.0 — CMake (cmake 4.1 ya instalado en el chroot por el workflow).
set -euo pipefail
rm -rf build && rm -rf build && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTS=OFF -DBUILD_DOC=OFF -DBUILD_EXAMPLES=OFF \
  -DSDBUSCPP_BUILD_TESTS=OFF \
  ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
