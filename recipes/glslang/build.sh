#!/bin/bash
# glslang 15.4.0 — BLFS 12.4 (cmake + ninja):
#   cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DALLOW_EXTERNAL_SPIRV_TOOLS=ON \
#         -DBUILD_SHARED_LIBS=ON -DGLSLANG_TESTS=OFF -G Ninja .. && ninja
# BUILD_EXTERNAL=OFF: no clonar spirv-tools en External/; usa el instalado.
set -euo pipefail
rm -rf build && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DALLOW_EXTERNAL_SPIRV_TOOLS=ON -DBUILD_EXTERNAL=OFF -DBUILD_SHARED_LIBS=ON -DGLSLANG_TESTS=OFF -DENABLE_GLSLANG_INSTALL=ON -G Ninja ..
ninja
DESTDIR="$DESTDIR" ninja install
