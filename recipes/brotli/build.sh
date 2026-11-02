#!/bin/bash
# brotli 1.1.0 - CMake. Libs compartidas ON: instala libbrotli*.so +
# /usr/lib/cmake/Brotli (find_package(Brotli) de libjxl lo usa).
set -euo pipefail
mkdir -p build
cd build
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF -DBROTLI_DISABLE_TESTS=ON \
  -DBROTLI_ENABLE_SANITIZERS=OFF ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
