#!/bin/bash
# libnotify 0.8.7 — MESON (0.8.x ya no trae configure/autogen; autoreconf falla sin configure.ac).
# Opciones validadas contra meson_options.txt de 0.8.7: tests/man/gtk_doc boolean, introspection/docbook_docs feature.
set -euo pipefail
meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared \
  -Dtests=false -Dman=false -Dgtk_doc=false -Ddocbook_docs=disabled -Dintrospection=disabled
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
