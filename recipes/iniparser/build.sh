#!/bin/bash
# iniparser 4.2.6 — cmake (tarball release trae CMakeLists).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cmake -S "$d" -B build -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DINIPARSER_BUILD_DOCS=OFF
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
