#!/bin/bash
# bluez 5.86 — autotools (configure pre-generado; ell/ vendored). Sin systemd.
set -euo pipefail
./configure --prefix=/usr --disable-systemd --disable-manpages \
  --enable-udev --enable-library --disable-cups --disable-obex
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
