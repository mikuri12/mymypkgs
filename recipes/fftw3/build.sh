#!/bin/bash
# FFTW 3.3.10 — autotools (tarball release con configure).
set -euo pipefail
./configure --prefix=/usr --disable-static --enable-shared --enable-threads --with-combined-threads
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
# /usr/share/info/dir ya lo posee libffi en el rootfs: quitarlo del staging
# para que pkg-install no aborte por conflicto de archivos.
unlink "$DESTDIR/usr/share/info/dir" 2>/dev/null || true
