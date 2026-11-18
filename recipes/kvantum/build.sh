#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
[ -f "$d/CMakeLists.txt" ] || d=$(find "$d" -maxdepth 1 -mindepth 1 -type d | head -1)  # tarball GitHub anida CMakeLists en Kvantum/
cmake -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
