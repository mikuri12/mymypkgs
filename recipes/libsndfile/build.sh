#!/bin/bash
# libsndfile 1.2.2 — CMake. Solo decodificación interna; sin externas opcionales.
set -euo pipefail
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF \
  -DBUILD_PROGRAMS=OFF -DENABLE_EXTERNAL_LIBS=OFF \
  -DENABLE_MPEG=OFF ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
