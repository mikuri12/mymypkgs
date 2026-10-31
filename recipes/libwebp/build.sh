#!/bin/bash
# libwebp 1.6.0 — autotools (BLFS 12.4 flags exactos).
set -euo pipefail
./configure --prefix=/usr \
  --enable-libwebpmux --enable-libwebpdemux --enable-libwebpdecoder \
  --enable-libwebpextras --enable-swap-16bit-csp --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
