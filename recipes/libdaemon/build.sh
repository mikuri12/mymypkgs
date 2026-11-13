#!/bin/bash
# libdaemon 0.14 — autotools (configure incluido en el tarball oficial).
set -euo pipefail
./configure --prefix=/usr --disable-static --disable-lynx
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
