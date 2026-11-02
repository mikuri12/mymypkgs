#!/bin/bash
# lcms2 2.16 — autotools. Libs + headers (pkg-config lcms2) para libjxl.
set -euo pipefail
./configure --prefix=/usr --disable-static --without-python --without-jpeg --without-tiff
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
