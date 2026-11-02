#!/bin/bash
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr -D docs=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
