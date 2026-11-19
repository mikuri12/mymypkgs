#!/bin/bash
# wf-recorder 0.6.0 — meson. Audio solo pipewire (pulse off), backend pipewire.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dpipewire=enabled -Dpulse=disabled -Ddefault_audio_backend=pipewire
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
