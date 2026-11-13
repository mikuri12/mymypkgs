#!/bin/bash
# ffmpeg 8.0 — configure (no cmake). Sin autodetect para no enganchar libs
# sueltas del chroot; zlib explícito (está como paquete). Sin x86asm (no nasm).
set -euo pipefail
./configure --prefix=/usr --libdir=/usr/lib \
  --disable-doc --disable-debug --disable-x86asm --disable-autodetect \
  --enable-shared --disable-static --enable-gpl --enable-zlib
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
