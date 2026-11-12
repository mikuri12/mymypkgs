#!/bin/bash
# playerctl 2.4.1 — meson. glib ya instalado en el chroot (paquete publicado).
# AVISO (run 43148474382): en playerctl 2.4.1 introspection y gtk-doc son
# opciones BOOLEANAS (meson_options.txt), no features: -Dintrospection=disabled
# aborta el setup (value disabled is not boolean). Ademas gtk-doc esta en true
# por defecto y el chroot no tiene gtkdoc-scan -> hay que desactivarlo.
set -euo pipefail
mkdir -p build && cd build
meson setup --prefix=/usr --buildtype=release \
  -Dintrospection=false -Dgtk-doc=false \
  -Dbash-completions=false -Dzsh-completions=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
