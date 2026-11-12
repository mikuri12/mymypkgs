#!/bin/bash
# libplacebo 7.387.0 — meson. vulkan contra vulkan-loader instalado; shaderc
# OFF (no hace falta en iGPU HD530); lcms ON (lcms2 en el sistema); resto OFF.
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release \
  -Dvulkan=enabled -Dshaderc=disabled -Dglslang=disabled -Dlcms=enabled \
  -Ddovi=disabled -Dlibdovi=disabled -Dunwind=disabled -Dopengl=disabled \
  -Ddemos=false -Dtests=false -Dbench=false -Dfuzz=false
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
