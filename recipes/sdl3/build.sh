#!/bin/bash
# SDL3 3.4.18 — cmake. Sin X11; Wayland + ALSA + PipeWire.
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DSDL_SHARED=ON -DSDL_STATIC=OFF \
  -DSDL_X11=OFF -DSDL_WAYLAND=ON -DSDL_ALSA=ON -DSDL_PIPEWIRE=ON \
  -DSDL_PULSEAUDIO=OFF -DSDL_JACK=OFF \
  -DSDL_TESTS=OFF -DSDL_EXAMPLES=OFF
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
