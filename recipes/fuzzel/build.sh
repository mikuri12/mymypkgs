#!/bin/bash
# fuzzel 1.15.0 — tllist/fcft/scdoc YA extraídos por build-pkg.sh desde sources.
# fuzzel 1.15.0 NO tiene opción para desactivar doc/: doc/meson.build exige
# scdoc como build-time dep SIEMPRE → se compila e instala en el chroot antes de meson setup.
set -euo pipefail
STAGING="$DESTDIR"
unset DESTDIR
cd /tmp/build/scdoc-1.11.3
make PREFIX=/usr
make PREFIX=/usr install
cd ..
cd /tmp/build/tllist
meson setup --prefix=/usr build --buildtype=release
ninja -C build && ninja -C build install
cd ..
cd /tmp/build/fcft
meson setup --prefix=/usr build --buildtype=release -D docs=disabled -D examples=false
ninja -C build && ninja -C build install
cd ..
cd /tmp/build/fuzzel-1.15.0
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -D png-backend=libpng ..
ninja
DESTDIR="$STAGING" ninja install
