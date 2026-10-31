#!/bin/bash
# tomlplusplus 3.4.0 — meson header-only.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
