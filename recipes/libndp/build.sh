#!/bin/bash
# libndp 1.9 — autotools (el tarball del repo trae configure pre-generado).
set -euo pipefail
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
