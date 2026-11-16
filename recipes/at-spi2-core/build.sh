#!/bin/bash
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared -Duse_systemd=false -Ddbus_daemon=/usr/bin/dbus-daemon --wrap-mode=nodownload
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
# at-spi2-core 2.56 integra atk: no pisar el paquete atk ya publicado
rm -rf "$DESTDIR"/usr/include/atk-1.0 "$DESTDIR"/usr/lib/libatk* "$DESTDIR"/usr/lib/pkgconfig/atk.pc "$DESTDIR"/usr/share/gtk-doc/html/atk* "$DESTDIR"/usr/share/gir-1.0/Atk* "$DESTDIR"/usr/lib/girepository-1.0/Atk*
