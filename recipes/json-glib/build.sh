#!/bin/bash
# json-glib 1.10.8 — meson. Opciones VERIFICADAS contra meson_options.txt:
#   introspection/documentation/gtk_doc/nls = feature ; man/tests/conformance/
#   installed_tests = boolean
# introspection fuera (no hay gobject-introspection en el chroot y no lo usa
# Noctalia/Halley); documentation fuera (gi-docgen ausente); tests fuera.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D introspection=disabled \
  -D documentation=disabled \
  -D gtk_doc=false \
  -D man=false \
  -D tests=false \
  -D conformance=false \
  -D installed_tests=false \
  -D nls=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
