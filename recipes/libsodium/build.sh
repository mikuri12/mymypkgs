#!/bin/bash
# libsodium 1.0.20 — autotools. Sin tests/docs.
set -euo pipefail
./configure --prefix=/usr --disable-static --disable-dependency-tracking
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
