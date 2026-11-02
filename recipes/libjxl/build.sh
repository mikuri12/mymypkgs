#!/bin/bash
# libjxl 0.11.1 — CMake (flags BLFS 12.4). Sin tests (gtest), sin skcms/sjpeg,
# tools OFF (asi no se compila jxl_extras.cmake ni se exige giflib).
# highway y brotli vienen de sistema (find_package HWY/Brotli en third_party).
set -euo pipefail
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF \
  -DJPEGXL_ENABLE_SKCMS=OFF -DJPEGXL_ENABLE_SJPEG=OFF \
  -DJPEGXL_ENABLE_BENCHMARK=OFF -DJPEGXL_ENABLE_EXAMPLES=OFF \
  -DJPEGXL_ENABLE_TOOLS=OFF -DJPEGXL_ENABLE_JNI=OFF \
  -DJPEGXL_ENABLE_OPENEXR=OFF -DJPEGXL_ENABLE_MANPAGES=OFF \
  -DJPEGXL_ENABLE_DOXYGEN=OFF -DJPEGXL_ENABLE_FUZZERS=OFF \
  -DJPEGXL_ENABLE_DEVTOOLS=OFF -DJPEGXL_ENABLE_PLUGINS=OFF \
  -DJPEGXL_FORCE_SYSTEM_HWY=ON -DJPEGXL_FORCE_SYSTEM_BROTLI=ON \
  ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
