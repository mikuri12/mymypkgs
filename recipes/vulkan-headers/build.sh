#!/bin/bash
# Vulkan-Headers 1.4.368 — cmake (solo instala headers + pkg-config/cmake config).
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
