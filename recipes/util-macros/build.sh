#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
[ -f configure ] || autoreconf -fi
./configure --prefix=/usr
DESTDIR="$DESTDIR" make install
