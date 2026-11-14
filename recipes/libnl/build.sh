#!/bin/bash
# libnl 3.11.0 — el asset de GitHub releases es tarball AUTOTOOLS (configure,
# SIN CMakeLists.txt en la raiz): cmake fallaba con "does not appear to contain
# CMakeLists.txt". Build con configure/make.
set -euo pipefail
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
