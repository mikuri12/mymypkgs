#!/bin/bash
set -euo pipefail
[ -f configure ] || { [ -f autogen.sh ] && NOCONFIGURE=1 ./autogen.sh || autoreconf -fi; }
ln -sf inputproto.pc /usr/share/pkgconfig/xi.pc 2>/dev/null || true
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
