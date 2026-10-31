#!/bin/bash
# nlohmann-json 3.12.0 — CMake header-only. Sin tests.
set -euo pipefail
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DJSON_BuildTests=OFF -DJSON_Install=ON ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
