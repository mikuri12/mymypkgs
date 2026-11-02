#!/bin/bash
# libevdev 1.10.0 — BLFS 12.12.4 (meson). Sin docs.
set -euo pipefail
rm -rf build && rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -D documentation=disabled -D tests=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
