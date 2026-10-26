#!/bin/bash
# alsa-lib 1.2.14 — BLFS 12.4 (autotools). Sin python (topology docs off).
set -euo pipefail
./configure --prefix=/usr --disable-static --with-python=no
make
DESTDIR="$DESTDIR" make install
rm -rf "$DESTDIR/usr/share/alsa/{topology,ucm,ucm2}" || true
