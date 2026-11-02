#!/bin/bash
# libical 3.0.20 — CMake. ICU es requerida por defecto en 3.0.x; si no está,
# se puede -DICAL_ENABLE_UNICODE=OFF, pero glib+libxml2 alcanzan.
set -euo pipefail
rm -rf build && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DICAL_BUILD_DOCS=OFF -DGOBJECT_INTROSPECTION=OFF -DICAL_GLIB=ON \
  -DICAL_BUILD_TESTS=OFF ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
