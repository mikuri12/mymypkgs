#!/bin/bash
# playerctl 2.4.1 — meson. glib ya instalado en el chroot (paquete publicado).
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -Dintrospection=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
