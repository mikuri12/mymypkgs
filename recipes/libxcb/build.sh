#!/bin/bash
# libxcb 1.17.0 — autotools (NO meson: el tarball upstream es autotools).
set -euo pipefail
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
