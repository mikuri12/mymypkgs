#!/bin/bash
# recipes/libdrm/build.sh — corre dentro del chroot, cwd = fuentes extraídas.
# Instrucciones BLFS 12.4 (libdrm 2.4.125) con DESTDIR staging del PLAN.
set -euo pipefail

# XORG_PREFIX=/usr en un sistema LFS (BLFS asume LFS: todo en /usr)
export XORG_PREFIX=/usr

mkdir build
cd    build

meson setup --prefix=$XORG_PREFIX \
            --buildtype=release   \
            -D udev=true          \
            -D valgrind=disabled  \
            ..

ninja

# RUN_TESTS=0 (PLAN): no corremos 'ninja test'

# Instalar a staging (DESTDIR lo exporta build-pkg.sh)
DESTDIR="$DESTDIR" ninja install

# .pc y symlinks quedan dentro del staging; nothing to fix (prefix /usr)
