#!/bin/bash
# libinput 1.29.0 — BLFS 12.4 (meson). Sin docs/tests.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D documentation=false -D tests=false -D libwacom=false -D debug-gui=false ..
ninja
DESTDIR="$DESTDIR" ninja install
