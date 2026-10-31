#!/bin/bash
# wl-clipboard 2.3.0 — meson.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
