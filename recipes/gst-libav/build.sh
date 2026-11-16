#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
# gst-libav 1.26.8 meson_options solo tiene: package-name, package-origin, doc, tests (sin examples/gtk_doc)
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared -Dtests=disabled -Ddoc=disabled
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
