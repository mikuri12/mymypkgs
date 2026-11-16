#!/bin/bash
set -euo pipefail
meson setup build --wrap-mode=nodownload --prefix=/usr --buildtype=release --libdir=lib --default-library=shared
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
# at-spi2-core 2.56 ya instala atk-bridge.h / atk-bridge-2.0.pc / módulo gtk2: no pisarlos
rm -f "$DESTDIR"/usr/include/at-spi2-atk/2.0/atk-bridge.h "$DESTDIR"/usr/lib/pkgconfig/atk-bridge-2.0.pc "$DESTDIR"/usr/lib/gtk-2.0/modules/libatk-bridge.so; rm -rf "$DESTDIR"/usr/lib/gnome-settings-daemon-3.0
