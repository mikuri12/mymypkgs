#!/bin/bash
# GTK 3.24.49 — meson, shared. Wayland ON (Halley), X11 OFF (sin libX11 en rootfs).
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dwayland-backend=true -Dx11-backend=false -Dbroadway-backend=false -Dwin32-backend=false -Dquartz-backend=false \
  -Dintrospection=false -Ddemos=false -Dtests=false -Dexamples=false -Ddocs=false -Dman=false \
  -Dprint-cups=disabled -Dprint-cloudprint=disabled -Dtracker=disabled -Dcolord=disabled \
  -Dvulkan=disabled -Dmedia-gstreamer=disabled
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
