#!/bin/bash
# fontconfig 2.17.1 — meson (meson.options). Opciones reales: doc/doc-txt/
# doc-man/doc-pdf/doc-html/nls/tests/tools = feature; cache-build = feature;
# iconv = feature; xml-backend = combo (auto/expat/libxml2); fontations = feature;
# default-hinting/default-sub-pixel-rendering/bitmap-conf = combo.
# xml-backend=expat (expat ya está en el chroot), sin docs, sin tests, sin tools.
set -euo pipefail
rm -rf build && rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D xml-backend=expat \
  -D fontations=disabled \
  -D doc=disabled -D doc-txt=disabled -D doc-man=disabled \
  -D doc-pdf=disabled -D doc-html=disabled \
  -D nls=disabled \
  -D tests=disabled \
  -D tools=disabled \
  -D cache-build=enabled \
  -D iconv=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
