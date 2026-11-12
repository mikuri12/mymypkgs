#!/bin/bash
# mpv 0.41.0 — meson. Desde mpv 0.40 libass y libplacebo son HARD deps (ya no
# existen las opciones -Dlibass/-Dlibplacebo: meson falla con Unknown options);
# van como paquetes aparte (libass, libplacebo) en depends/makedepends.
# Wayland+EGL+GL; audio alsa+pipewire; ffmpeg 8.0 para demux/decode.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -Dlibarchive=disabled -Dvapoursynth=disabled -Ddvdnav=disabled \
  -Dcdda=disabled -Drubberband=disabled -Dzimg=disabled \
  -Duchardet=disabled -Dcplugins=disabled \
  -Dgl=enabled -Dwayland=enabled -Degl=enabled \
  -Dalsa=enabled -Dpipewire=enabled -Dlua=enabled ..
ninja
DESTDIR="$DESTDIR" ninja install
