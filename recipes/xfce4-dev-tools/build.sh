#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
if [ ! -f configure ]; then autoreconf -fi; fi
./configure --prefix=/usr
DESTDIR="$DESTDIR" make install
