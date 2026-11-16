#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared -Dtests=disabled -Dexamples=disabled -Dgtk_doc=disabled
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
