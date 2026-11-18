#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cmake -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DINSTALL_EXAMPLESDIR=share/qt6/examples -DQT_FEATURE_opengl=ON -DQT_FEATURE_xcb=ON -DQT_FEATURE_wayland=ON -DQT_FEATURE_dbus=ON
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
