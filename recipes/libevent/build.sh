#!/bin/bash
# libevent 2.1.12 — autotools (tarball release con configure pre-generado).
set -euo pipefail
./configure --prefix=/usr --disable-static --disable-libevent-regress
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
