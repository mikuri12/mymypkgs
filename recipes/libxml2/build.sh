#!/bin/bash
# libxml2 2.14.5 (BLFS 12.4) — meson; sin docs/python/tests.
set -euo pipefail
STAGING="$DESTDIR"
unset DESTDIR
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -D tests=disabled -D docs=disabled -D python=disabled ..
ninja
DESTDIR="$STAGING" ninja install
