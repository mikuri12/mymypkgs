#!/bin/bash
# foot 1.27.0 — meson; fcft/tllist/pixman/utf8proc como deps embebidas
# (mismo patrón que fuzzel; foot las requiere en runtime).
set -euo pipefail
TLLIST=1.1.0
FCFT=3.3.1
UTF8PROC=2.10.0
curl -fsSL --retry 3 -o tllist.tar.gz "https://codeberg.org/dnkl/tllist/archive/${TLLIST}.tar.gz"
curl -fsSL --retry 3 -o fcft.tar.gz "https://codeberg.org/dnkl/fcft/archive/${FCFT}.tar.gz"
curl -fsSL --retry 3 -o utf8proc.tar.gz "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v${UTF8PROC}.tar.gz"
tar -xzf tllist.tar.gz && cd tllist
meson setup --prefix=/usr build --buildtype=release
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
tar -xzf utf8proc.tar.gz && cd utf8proc-*
meson setup --prefix=/usr build --buildtype=release
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
tar -xzf fcft.tar.gz && cd fcft
meson setup --prefix=/usr build --buildtype=release -D docs=disabled -D examples=disabled
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D docs=disabled -D man=disabled -D tests=disabled \
  -D server-name=foot ..
ninja
DESTDIR="$DESTDIR" ninja install
