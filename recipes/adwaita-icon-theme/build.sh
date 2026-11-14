#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
./configure --prefix=/usr --disable-legacy-svg
DESTDIR="$DESTDIR" make install
