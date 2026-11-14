#!/bin/bash
# GTK 3.24.49 — meson, shared. Wayland ON (Halley), X11 OFF (sin libX11 en rootfs).
# Opciones validadas contra meson_options.txt de 3.24.49: introspection/gtk_doc/man/
# demos/tests/examples son boolean (false); print-cups, print-cloudprint, tracker,
# vulkan y media-gstreamer NO existen como opciones en 3.24 (print_backends es
# string y tracker3 boolean aparte); colord es combo yes/no/auto.
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dwayland_backend=true -Dx11_backend=false -Dbroadway_backend=false -Dwin32_backend=false -Dquartz_backend=false \
  -Dintrospection=false -Ddemos=false -Dtests=false -Dexamples=false -Dgtk_doc=false -Dman=false \
  -Dcolord=no
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
