#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
./configure --prefix=/usr --disable-static ${EXTRA:-}
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
