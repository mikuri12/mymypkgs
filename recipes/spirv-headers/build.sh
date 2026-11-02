#!/bin/bash
# spirv-headers vulkan-sdk-1.4.321.0 — SOLO headers (BLFS 12.4):
#   rm -rf build && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && ninja install
# instala /usr/include/spirv + cmake config. Sin libs.
set -euo pipefail
rm -rf build && mkdir build && cd build
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -G Ninja ..
ninja
DESTDIR="$DESTDIR" ninja install
