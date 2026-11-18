#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
meson setup build "$d" --prefix=/usr --buildtype=release
meson compile -C build
DESTDIR="$DESTDIR" meson install -C build
