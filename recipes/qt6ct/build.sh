#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
sed -i "s/Core Widgets OPTIONAL_COMPONENTS/Core Widgets WidgetsPrivate GuiPrivate OPTIONAL_COMPONENTS/" "$d/CMakeLists.txt"
sed -i 's|private/qgenericunixthemes_p.h|private/qgenericunixtheme_p.h|' "$d/src/qt6ct-qtplugin/qt6ctplatformtheme.h"
cmake -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
