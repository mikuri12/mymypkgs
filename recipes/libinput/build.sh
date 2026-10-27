#!/bin/bash
# libinput 1.29.0 — BLFS 12.4 (meson). Sin docs/tests.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D documentation=false -D tests=disabled -D libwacom=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
