#!/bin/bash
# cava 0.10.6 — autotools (autogen.sh en tarball de git).
set -euo pipefail
./configure --prefix=/usr
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
