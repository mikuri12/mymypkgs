#!/bin/bash
# wayland 1.24.0 — BLFS 12.4 (meson). Sin docs (PLAN).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -D documentation=false ..
ninja
DESTDIR="$DESTDIR" ninja install
