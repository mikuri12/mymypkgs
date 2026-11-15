#!/bin/bash
set -euo pipefail
meson setup build --wrap-mode=nodownload --prefix=/usr --buildtype=release --libdir=lib --default-library=shared
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
