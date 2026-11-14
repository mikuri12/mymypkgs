#!/bin/bash
set -euo pipefail
./configure --prefix=/usr --disable-static --without-python --without-crypto
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
