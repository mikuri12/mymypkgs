#!/bin/bash
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared -Ddbus_daemon=/usr/bin/dbus-daemon -Dsystemd_units=false
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
