#!/bin/bash
# MangoHud v0.8.4 — meson. Sin X11 ni xnvctrl (no hay libX11/libXNVCtrl en el
# rootfs Wayland); wayland sí. Sin nvml (driver NVIDIA no aplica).
set -euo pipefail
# El tarball ya trae subprojects/*.wrap; les damos los archivos en packagecache
# para que meson no intente descargar (el chroot no tiene certificados CA).
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
mkdir -p "$d/subprojects/packagecache"
for f in /lfs/sources/mangohud__packagecache/*; do
  [ -e "$f" ] && cp -v "$f" "$d/subprojects/packagecache/"
done
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -Dwith_x11=disabled -Dwith_xnvctrl=disabled -Dwith_nvml=disabled \
  -Dmangoapp=false -Dtests=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
