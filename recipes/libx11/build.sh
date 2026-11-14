#!/bin/bash
set -euo pipefail
[ -f configure ] || { [ -f autogen.sh ] && NOCONFIGURE=1 ./autogen.sh || autoreconf -fi; }
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
