#!/bin/bash
# hwdata 0.398 — autotools trivial (BLFS 12.4): ./configure --prefix=/usr
# --disable-blacklist; instala los .ids en /usr/share/hwdata.
set -euo pipefail
./configure --prefix=/usr --disable-blacklist
DESTDIR="$DESTDIR" make install
