#!/bin/bash
set -euo pipefail
# fuente 1 = libtorrent; fuente 2 = submodulo deps/try_signal (los tarballs
# de codeload NO incluyen submodulos y CMakeLists.txt:547 referencia
# deps/try_signal/try_signal.cpp -> "Cannot find source file")
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d -name 'libtorrent-*' | head -1)
ts=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d -name 'try_signal-*' | head -1)
mkdir -p "$d/deps/try_signal"
cp -a "$ts/." "$d/deps/try_signal/"
cmake -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -Dbuild_tests=OFF -Dbuild_examples=OFF -Dpython-bindings=OFF
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
