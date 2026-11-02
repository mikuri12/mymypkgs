#!/bin/bash
# libqalculate 5.8.1 — autotools. Sin gettext/libcurl/mpfr/iconv extra.
set -euo pipefail
./configure --prefix=/usr --disable-static --without-libcurl --without-mpfr \
  --disable-text-ui --without-icu
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
