#!/bin/bash
# fuzzel 1.15.0 — necesita fcft (+tllist) y pixman/libpng; la base LFS no
# los trae. Se compilan aquí mismo (una sola vez, build-implícito) porque
# el PLAN exige paquetes mínimos y fcft es único usuario.
set -euo pipefail
TLLIST=1.1.0
FCFT=3.3.1
curl -fsSL --retry 3 -o tllist.tar.gz "https://codeberg.org/dnkl/tllist/archive/${TLLIST}.tar.gz"
curl -fsSL --retry 3 -o fcft.tar.gz "https://codeberg.org/dnkl/fcft/archive/${FCFT}.tar.gz"
tar -xzf tllist.tar.gz && cd tllist
meson setup --prefix=/usr build --buildtype=release
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
tar -xzf fcft.tar.gz && cd fcft
meson setup --prefix=/usr build --buildtype=release \
  -D docs=disabled -D examples=disabled
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
# fuzzel mismo
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -D docs=disabled -D man=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
