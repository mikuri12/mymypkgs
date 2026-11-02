#!/bin/bash
# expat 2.6.4 — CMake (cmake 4.1 ya instalado en el chroot por el workflow).
# Sin tools ni docs; con pkgconfig (meson lo encuentra por pkg-config).
set -euo pipefail
rm -rf build && mkdir build && cd build
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DEXPAT_BUILD_TOOLS=OFF \
  -DEXPAT_BUILD_DOCS=OFF \
  -DEXPAT_BUILD_PKGCONFIG=ON \
  -DEXPAT_BUILD_EXAMPLES=OFF \
  -DEXPAT_BUILD_TESTS=OFF \
  -DEXPAT_SHARED_LIBS=ON \
  ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
