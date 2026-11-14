#!/bin/bash
# Vulkan-Loader 1.4.368 — cmake. WSI wayland ON: mpv (wayland+vulkan) linkea vkCreateWaylandSurfaceKHR (run 43356043793: undefined reference en el link). Sin dep de build extra; xlib/xcb/directfb siguen OFF (headless).
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DVULKAN_HEADERS_INSTALL_DIR=/usr \
  -DBUILD_TESTS=OFF -DBUILD_WSI_XLIB_SUPPORT=OFF -DBUILD_WSI_XCB_SUPPORT=OFF \
  -DBUILD_WSI_WAYLAND_SUPPORT=ON -DBUILD_WSI_DIRECTFB_SUPPORT=OFF
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
