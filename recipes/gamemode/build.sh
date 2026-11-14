#!/bin/bash
# gamemode 1.8.2 — meson. SysV: no-daemon sd-bus, sin unit systemd, sin renicing PAM.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -Dwith-sd-bus-provider=no-daemon \
  -Dwith-systemd-user-unit=false -Dwith-pam-renicing=false \
  -Dwith-examples=false ..
ninja
DESTDIR="$DESTDIR" ninja install
