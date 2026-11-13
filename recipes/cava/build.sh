#!/bin/bash
# cava 0.10.6 — autotools (autogen.sh en tarball de git).
set -euo pipefail
NOCONFIGURE=1 ./autogen.sh
./configure --prefix=/usr
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
