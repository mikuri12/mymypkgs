#!/bin/bash
# xtrans 1.5.2 — autotools (tarball oficial trae configure). Solo headers + xtrans.pc + xtrans.m4
set -euo pipefail
[ -f configure ] || autoreconf -fi
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
