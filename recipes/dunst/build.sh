#!/bin/bash
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared -Dwayland=enabled -Dx11=enabled -Dsystemd=disabled
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
