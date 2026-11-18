#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cmake -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DQT6=ON -DWEBUI=ON -DDBUS=ON -DGUI=ON
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
