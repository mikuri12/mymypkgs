#!/bin/bash
# basu 0.2.1 — meson. Genera libbasu.so + basu.pc (filebase=project_name).
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release -Daudit=disabled -Dlibcap=disabled
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
