#!/bin/bash
# SPIRV-Tools vulkan-sdk-1.4.321.0 — BLFS 12.4 (cmake + ninja):
#   cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DSPIRV_WERROR=OFF \
#         -DBUILD_SHARED_LIBS=ON -DSPIRV_TOOLS_BUILD_STATIC=OFF -DSPIRV-Headers_SOURCE_DIR=/usr -G Ninja ..
# El tarball NO trae external/spirv-headers; con los headers ya instalados
# en /usr/include/spirv por spirv-headers el include por defecto los cubre.
set -euo pipefail
rm -rf build && mkdir build && cd build
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DSPIRV_WERROR=OFF -DBUILD_SHARED_LIBS=ON -DSPIRV_TOOLS_BUILD_STATIC=OFF -DSPIRV-Headers_SOURCE_DIR=/usr -DSKIP_SPIRV_TOOLS_INSTALL=OFF -G Ninja ..
ninja
DESTDIR="$DESTDIR" ninja install
