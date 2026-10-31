#!/bin/bash
# mtdev 1.1.7 — autotools.
set -euo pipefail
./configure --prefix=/usr --disable-static
make
DESTDIR="$DESTDIR" make install
