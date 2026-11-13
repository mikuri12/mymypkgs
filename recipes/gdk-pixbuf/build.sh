#!/bin/bash
# gdk-pixbuf 2.44.8 — meson.
# Opciones VERIFICADAS contra meson_options.txt: png/tiff/jpeg/gif/others/
# introspection = feature ; builtin_loaders = array ; gtk_doc(deprecated->documentation)/documentation/man/
# tests/installed_tests/relocatable = boolean
#
# Solo PNG (hay libpng en el chroot) + GIF (builtin, sin dependencia externa).
# jpeg/tiff/others OFF: libjpeg/libtiff NO están en el chroot (y son pesados);
# el builtin de jpeg no requiere libjpeg pero su loader está deprecated, así que
# se deja fuera (xdg-desktop-portal solo necesita PNG para sus iconos).
# documentation(gtk_doc)/man/introspection fuera: no hay gi-docgen/xmlto/xsltproc.
# glycin=disabled: en Linux 2.44.8 enable_auto_if(linux) => dependency(glycin-2) OBLIGATORIA (meson.build:263); thumbnailer fuera tb.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D png=enabled \
  -D gif=enabled \
  -D jpeg=disabled \
  -D tiff=disabled \
  -D others=disabled \
  -D builtin_loaders=png \
  -D gtk_doc=false \
  -D man=false \
  -D introspection=disabled \
  -D tests=false \
  -D installed_tests=false \
  -D relocatable=false \
  -D gio_sniffing=false \
  -D glycin=disabled \
  -D thumbnailer=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
