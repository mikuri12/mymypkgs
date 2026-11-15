#!/bin/bash
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared -Dsystemd_user_unit_dir=/usr/lib/systemd/user -Ddbus_daemon=/usr/bin/dbus-daemon
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
