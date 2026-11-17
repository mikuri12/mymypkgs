#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
./autogen.sh 2>/dev/null || autoreconf -fi
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
