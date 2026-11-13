#!/bin/bash
# Vulkan-Headers 1.4.368 — cmake (solo instala headers + pkg-config/cmake config).
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
# OJO: NO crear vulkan.pc aquí — vulkan-loader ya lo instala y chocaría
# (CONFLICTO /usr/lib/pkgconfig/vulkan.pc). dependency('vulkan') se resuelve
# con el .pc del loader.
