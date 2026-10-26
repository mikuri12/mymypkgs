#!/bin/bash
# foot 1.27.0 — meson. Las deps (tllist, fcft, utf8proc) YA están extraídas
# en el cwd por build-pkg.sh (todas las sources del recipe.toml).
set -euo pipefail

# tllist
cd tllist
meson setup --prefix=/usr build --buildtype=release
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..

# utf8proc (dir utf8proc-2.10.0 o utf8proc-*)
cd utf8proc-*
meson setup --prefix=/usr build --buildtype=release
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..

# fcft (sin docs/examples)
cd fcft
meson setup --prefix=/usr build --buildtype=release -D docs=disabled -D examples=disabled
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..

# foot mismo
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D docs=disabled -D man=disabled -D tests=disabled \
  -D server-name=foot ..
ninja
DESTDIR="$DESTDIR" ninja install
