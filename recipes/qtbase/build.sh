#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cmake --log-level=DEBUG -S "$d" -B build -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DINSTALL_EXAMPLESDIR=share/qt6/examples \
  -DFEATURE_icu=OFF -DQT_FEATURE_opengl=ON -DQT_FEATURE_xcb=ON -DQT_FEATURE_wayland=ON \
  -DQT_FEATURE_dbus=ON -DQT_FEATURE_fontconfig=ON -DQT_FEATURE_freetype=ON -DQT_FEATURE_harfbuzz=ON \
  -DQT_FEATURE_openssl=ON -DQT_FEATURE_sqlite=ON -DQT_FEATURE_system_zlib=ON -DQT_FEATURE_system_png=ON \
  -DQT_FEATURE_system_freetype=ON -DQT_FEATURE_system_harfbuzz=ON -DQT_FEATURE_system_pcre2=ON \
  -DQT_FEATURE_xkbcommon=ON -DQT_FEATURE_vulkan=OFF -DQT_GENERATE_SBOM=OFF -DQT_FEATURE_sbom=OFF
cmake --build build
DESTDIR="$DESTDIR" cmake --install build
