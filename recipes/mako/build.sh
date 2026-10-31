#!/bin/bash
# mako 1.3.10 — python (pip-less): meson-python vía setup. En chroot LFS
# sin pip: usar el build PEP 517 con python -m build no está; alternativa
# meson: mako 1.3.10 trae meson.build.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
