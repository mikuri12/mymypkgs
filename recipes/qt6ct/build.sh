#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
sed -i "s/Core Widgets OPTIONAL_COMPONENTS/Core Widgets WidgetsPrivate GuiPrivate OPTIONAL_COMPONENTS/" "$d/CMakeLists.txt"
cmake -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
