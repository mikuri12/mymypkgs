#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
# gst-plugins-ugly 1.26.8 meson_options: sin examples; top-level: gpl/nls/tests/package-name/doc
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared -Dtests=disabled -Ddoc=disabled -Dnls=disabled -Dgpl=disabled
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
