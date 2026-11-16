#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
./configure --prefix=/usr --disable-static --disable-qt --disable-skins2 --disable-nls --disable-a52 --disable-libgcrypt --enable-wayland --disable-xcb --disable-alsa --disable-pulse --disable-jack
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
