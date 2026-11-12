#!/bin/bash
# GLFW 3.4 — cmake. Wayland only, shared lib.
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_SHARED_LIBS=ON -DGLFW_BUILD_X11=OFF -DGLFW_BUILD_WAYLAND=ON \
  -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
