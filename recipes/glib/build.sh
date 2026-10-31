#!/bin/bash
# glib 2.84.4 — meson (BLFS 12.4). Sin docs/man/tests/introspection/selinux.
# Opciones verificadas contra meson.options del tarball 2.84.4.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D tests=false \
  -D documentation=false \
  -D man-pages=disabled \
  -D introspection=disabled \
  -D selinux=disabled \
  -D libmount=disabled \
  -D sysprof=disabled \
  -D dtrace=false \
  -D systemtap=false \
  -D nls=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
