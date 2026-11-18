#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
# enable_documentation=yes es el DEFAULT del configure (tarball Debian) -> man/ llama a
# xsltproc --nonet contra docbook.sourceforge.net y el chroot no tiene red (run 44287217605).
./configure --prefix=/usr --disable-static --disable-documentation ${EXTRA:-}
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
