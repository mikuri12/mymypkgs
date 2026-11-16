#!/bin/bash
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared --wrap-mode=nodownload -Duse_systemd=false -Ddbus_daemon=/usr/bin/dbus-daemon
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
