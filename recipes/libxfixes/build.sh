#!/bin/bash
# libXfixes 6.0.2 — autotools (tarball oficial trae configure)
set -euo pipefail
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
