#!/bin/bash
# Vulkan-Tools 1.4.368 — cmake. WSI Wayland only, sin Xlib/XCB, cube off.
# CMake 4: policy minimum por si algún submódulo declara <3.5.
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DBUILD_WSI_XLIB_SUPPORT=OFF -DBUILD_WSI_XCB_SUPPORT=OFF \
  -DBUILD_WSI_WAYLAND_SUPPORT=ON -DBUILD_WSI_DIRECTFB_SUPPORT=OFF \
  -DBUILD_CUBE=OFF -DBUILD_VULKANINFO=ON -DBUILD_TESTS=OFF
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
