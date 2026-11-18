#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
[ -f "$d/CMakeLists.txt" ] || d=$(find "$d" -maxdepth 1 -mindepth 1 -type d | head -1)  # tarball GitHub anida CMakeLists en Kvantum/
# V1.1.9 exige KF6WindowSystem 6.0.0 REQUIRED (run 44287218908) y no hay KF6 en el stack;
# -DWITHOUT_KF=ON define NO_KF y salta find_package/link de KF6.
cmake -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DWITHOUT_KF=ON
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
