#!/bin/bash
# ImageMagick 7.1.2-31 — tarball oficial con `configure` pre-generado.
# Sin X (-without-x), sin openmp, sin C++ API, sin perl.
set -euo pipefail
./configure --prefix=/usr \
  --without-x --disable-openmp --without-magick-plus-plus --without-perl \
  --with-jpeg --with-png --with-webp --with-freetype --with-fontconfig \
  --with-lcms --with-xml --with-zlib
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
