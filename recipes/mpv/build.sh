#!/bin/bash
# mpv 0.41.0 — meson. Wayland+EGL+GL sobre mesa/libglvnd; audio alsa+pipewire;
# ffmpeg 8.0 (paquete de este lote) para demux/decode.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -Dlibarchive=disabled -Dvapoursynth=disabled -Ddvdnav=disabled \
  -Dcdda=disabled -Drubberband=disabled -Dzimg=disabled \
  -Dlibplacebo=disabled -Dlibass=disabled -Duchardet=disabled \
  -Dgl=enabled -Dwayland=enabled -Degl=enabled \
  -Dalsa=enabled -Dpipewire=enabled -Dlua=enabled ..
ninja
DESTDIR="$DESTDIR" ninja install
