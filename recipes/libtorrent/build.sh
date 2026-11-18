#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cmake -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -Dbuild_tests=OFF -Dbuild_examples=OFF -Dpython-bindings=OFF
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
