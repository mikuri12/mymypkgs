#!/bin/bash
# hwdata 0.398 — configure + Makefile (SIN meson). Instala IDFILES en
# /usr/share/hwdata + hwdata.pc en /usr/share/pkgconfig con pkgdatadir
# = /usr/share/hwdata: libdisplay-info 0.4.0 resuelve pnp.ids via
# dependency(hwdata, native:true) en vez del fallback hardcodeado.
set -euo pipefail
./configure --prefix=/usr --datadir=/usr/share
make
DESTDIR="$DESTDIR" make install
