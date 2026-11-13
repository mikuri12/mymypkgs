#!/bin/bash
# FFTW 3.3.10 — autotools (tarball release con configure).
set -euo pipefail
./configure --prefix=/usr --disable-static --enable-shared --enable-threads --with-combined-threads
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
