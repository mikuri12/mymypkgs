#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
BUILDCC=gcc CC=gcc ./configure --prefix=/usr --disable-static --disable-qt --disable-skins2 --disable-nls --disable-a52 --disable-libgcrypt --enable-wayland --disable-xcb --disable-alsa --disable-pulse --disable-jack --disable-avcodec --disable-avformat --disable-swscale --disable-gl --disable-glx --disable-egl --disable-libva --disable-vdpau --disable-xvideo --disable-libvisual --disable-projectm --disable-goom --disable-glspectrum
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
