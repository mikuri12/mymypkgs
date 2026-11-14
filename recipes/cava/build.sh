#!/bin/bash
# cava 0.10.6 — autotools (autogen.sh en tarball de git).
set -euo pipefail
# tarball de tag sin configure → autogen (autotools en build_tools)
NOCONFIGURE=1 ./autogen.sh
./configure --prefix=/usr
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
