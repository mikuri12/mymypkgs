#!/bin/bash
# libxml2 2.14.5 (BLFS 12.4) — CMAKE (el meson de 2.14 exige git para
# versionado; git no está en la base LFS y el PLAN no lo quiere).
set -euo pipefail
STAGING="$DESTDIR"
unset DESTDIR
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DLIBXML2_WITH_PYTHON=OFF -DLIBXML2_WITH_TESTS=OFF \
      -DLIBXML2_WITH_ICU=OFF -DLIBXML2_WITH_LZMA=OFF -DLIBXML2_WITH_ZLIB=ON \
      -DLIBXML2_WITH_PROGRAMS=ON \
      ..
make -j"$(nproc)"
DESTDIR="$STAGING" make install
