#!/bin/bash
# dbus 1.16.2 — BLFS 12.4 (cmake): sin systemd, sin X, sin selinux.
set -euo pipefail
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release \
      -DDBUS_BUILD_TESTS=OFF \
      -DDBUS_DISABLE_ASSERT=ON \
      -DDBUS_ENABLE_X11_AUTOLAUNCH=OFF \
      -DENABLE_SYSTEMD=OFF \
      -W no ..
make
DESTDIR="$DESTDIR" make install
