#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
./Configure linux-x86_64 --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic
make -j"$(nproc)"
make install_sw DESTDIR="$DESTDIR"   # el Makefile de openssl define DESTDIR= vacío y pisa el env
